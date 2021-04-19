//
//  Permission.swift
//  RequestProcessing
//
//  Created by Tibor Bodecs on 2021. 03. 26..
//

public struct Permission: Codable, Equatable {

    public enum Action: Codable, Equatable {

        private enum CodingKeys: String, CodingKey {
            case list, get, create, update, patch, delete, custom
        }
        
        case list
        case get
        case create
        case update
        case patch
        case delete
        case custom(String)
        
        public static var crud: [Action] { [.list, .get, .create, .update, .patch, .delete] }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .list: try container.encode(true, forKey: .list)
            case .get: try container.encode(true, forKey: .get)
            case .create: try container.encode(true, forKey: .create)
            case .update: try container.encode(true, forKey: .update)
            case .patch: try container.encode(true, forKey: .patch)
            case .delete: try container.encode(true, forKey: .delete)
            case .custom(let value): try container.encode(value, forKey: .custom)
            }
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            switch container.allKeys.first {
            case .list: self = .list
            case .get: self = .get
            case .create: self = .create
            case .update: self = .update
            case .patch: self = .patch
            case .delete: self = .delete
            case .custom: self = .custom(try container.decode(String.self, forKey: .custom))
            default:
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Unabled to decode enum." ))
            }
        }
        
        public init(identifier: String) {
            switch identifier {
            case "list": self = .list
            case "get": self = .get
            case "create": self = .create
            case "update": self = .update
            case "patch": self = .patch
            case "delete": self = .delete
            default: self = .custom(identifier)
            }
        }
        
        public var identifier: String {
            switch self {
            case .list: return "list"
            case .get: return "get"
            case .create: return "create"
            case .update: return "update"
            case .patch: return "patch"
            case .delete: return "delete"
            case .custom(let value): return value
            }
        }
    }

    public let namespace: String
    public let context: String
    public let action: Action
    
    public init(namespace: String, context: String, action: Action) {
        self.namespace = namespace
        self.context = context
        self.action = action
    }

    public var components: [String] { [namespace, context, action.identifier] }

    public var identifier: String { components.joined(separator: ".").lowercased() }

    public var accessIdentifier: String { (components + ["access"]).joined(separator: "-").lowercased() }
    
    public var name: String { "\(namespace) \(context) \(action.identifier)" }
}


