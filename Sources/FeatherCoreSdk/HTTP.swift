//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 18..
//



enum HTTP {

    enum Error: LocalizedError {
        case invalidResponse
        case statusCode(Int)
        case unknown(Swift.Error)
    }

    enum Method: String {
        case get
        case post
        case put
        case patch
        case delete
    }

    public enum MIMEType: String {
        case json = "application/json"
    }

    enum Header {
        case accept([MIMEType])
        case contentType(MIMEType)
        case authorization(String)
        case custom(String, String)
        
        init(_ key: String, _ value: String) {
            switch key {
            default:
                self = .custom(key, value)
            }
        }

        public var key: String {
            switch self {
            case .accept:
                return "Accept"
            case .contentType:
                return "Content-Type"
            case .authorization:
                return "Authorization"
            case .custom(let key, _):
                return key
            }
        }

        public var value: String {
            switch self {
            case .accept(let types):
                return types.reduce("") { $0 + ", " + $1.rawValue }
            case .contentType(let type):
                return type.rawValue
            case .authorization(let token):
                return "Bearer \(token)"
            case .custom(_, let value):
                return value
            }
        }
    }

    public struct Response {
        public let statusCode: Int
        public let headers: [Header]
        public let data: Data

        public init(statusCode: Int, headers: [HTTP.Header], data: Data) {
            self.statusCode = statusCode
            self.headers = headers
            self.data = data
        }

        public var utf8String: String? {
            String(data: self.data, encoding: .utf8)
        }
    }

    public struct Request {
        public var method: Method
        public var url: URL
        public var headers: [Header]
        public var body: Data?

        public var urlRequest: URLRequest {
            var request = URLRequest(url: self.url)
            request.httpMethod = self.method.rawValue.uppercased()
            request.httpBody = self.body
            for header in self.headers {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
            return request
        }
        
        public init(method: HTTP.Method, url: URL, headers: [HTTP.Header] = [], body: Data? = nil) {
            self.method = method
            self.url = url
            self.headers = headers
            self.body = body
        }

        func perform() async throws -> HTTP.Response {
            let result = try await URLSession.shared.data(for: urlRequest)
            
            guard let response = result.1 as? HTTPURLResponse else {
                throw HTTP.Error.invalidResponse
            }
            guard 200...299 ~= response.statusCode else {
                throw HTTP.Error.statusCode(response.statusCode)
            }
            
            let headers = response.allHeaderFields.map { item in
                HTTP.Header(String(describing: item.key), String(describing: item.value))
            }

            return Response(statusCode: response.statusCode,
                            headers: headers,
                            data: result.0)
        }
    }
}
