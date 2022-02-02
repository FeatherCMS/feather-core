//
//  Request+Query.swift
//  Feather
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

public extension Request {

    /// turns the query into key-value paris separated by the proper url query characters
    var queryDictionary: [String: String] {
        var queryItems: [String: String] = [:]
        for queryItem in url.query?.split(separator: "&") ?? [] {
            let array = queryItem.split(separator: "=")
            guard array.count == 2 else {
                continue
            }
            let key = String(array[0])
            let value = String(array[1])
            queryItems[key] = value
        }
        return queryItems
    }
    
    func hasQuery(_ key: String) -> Bool {
        getQuery(key) != nil
    }
    
    /// Get a query parameter value as an optional string
    ///
    /// - Parameters:
    ///   - key: The key for a given query parameter value
    /// - Returns: The query parameter value as a String or a `nil` value
    ///
    func getQuery(_ key: String) -> String? {
        try? query.get(String.self, at: key)
    }
    
    func buildQuery(_ dict: [String: Any]) -> String {
        var queryItems = queryDictionary
        for (key, value) in dict {
            queryItems[key] = String(describing: value)
        }
        return "\(url.path)?\(queryItems.queryString)"
    }
    
}
