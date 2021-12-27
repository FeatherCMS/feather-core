//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

public struct FeatherPermission: Codable {

    public enum Action: Equatable, Codable {
        case list
        case detail
        case create
        case update
        case patch
        case delete
        case custom(String)
        
        public static var crud: [Action] {
            [
                .list,
                .detail,
                .create,
                .update,
                .patch,
                .delete
            ]
        }
        
        public init(_ key: String) {
            switch key {
            case "list": self = .list
            case "detail": self = .detail
            case "create": self = .create
            case "update": self = .update
            case "patch": self = .patch
            case "delete": self = .delete
            default: self = .custom(key)
            }
        }
        
        public var key: String {
            switch self {
            case .list: return "list"
            case .detail: return "detail"
            case .create: return "create"
            case .update: return "update"
            case .patch: return "patch"
            case .delete: return "delete"
            case .custom(let key): return key
            }
        }
    }
    
    enum CodingKeys: CodingKey {
        case namespace
        case context
        case action
    }
    
    public let namespace: String
    public let context: String
    public let action: Action
    
    public init(namespace: String, context: String, action: Action) {
        self.namespace = namespace
        self.context = context
        self.action = action
    }
    
    private let separator = "."
    
    public init(_ key: String) {
        let parts = key.components(separatedBy: separator)
        guard parts.count == 3 else {
            fatalError("Invalid permission key")
        }
        self.namespace = parts[0]
        self.context = parts[1]
        self.action = .init(parts[2])
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.namespace = try values.decode(String.self, forKey: .namespace)
        self.context = try values.decode(String.self, forKey: .context)
        let actionKey = try values.decode(String.self, forKey: .action)
        self.action = .init(actionKey)
    }

    public var components: [String] { [namespace, context, action.key] }
    
    public var key: String { components.joined(separator: separator) }

    public var accessKey: String { key + separator + "access" }
    
}

