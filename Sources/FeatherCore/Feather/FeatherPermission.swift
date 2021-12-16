//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Foundation

public struct FeatherPermission: Equatable, Codable, RawRepresentable {
    
    public enum Action: Equatable, Codable, ExpressibleByStringLiteral, CustomStringConvertible {
        case list
        case detail
        case create
        case update
        case patch
        case delete
        case custom(String)
        
        public static var crud: [Action] { [.list, .detail, .create, .update, .patch, .delete] }

        public init(stringLiteral value: String) {
            switch value {
            case "list": self = .list
            case "detail": self = .detail
            case "create": self = .create
            case "update": self = .update
            case "patch": self = .patch
            case "delete": self = .delete
            default: self = .custom(value)
            }
        }

        public var description: String {
            switch self {
            case .list: return "list"
            case .detail: return "detail"
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
    
    enum CodingKeys: CodingKey {
        case namespace
        case context
        case action
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.namespace = try values.decode(String.self, forKey: .namespace)
        self.context = try values.decode(String.self, forKey: .context)
        let rawAction = try values.decode(String.self, forKey: .action)
        self.action = .init(stringLiteral: rawAction)
    }

    public init?(rawValue: String) {
        let parts = rawValue.components(separatedBy: "-")
        guard parts.count == 3 else {
            return nil
        }
        self.namespace = parts[0]
        self.context = parts[1]
        self.action = .init(stringLiteral: parts[2])
    }
    
    public var rawValue: String {
        components.joined(separator: "-")
    }
    
    public var name: String { "\(namespace) \(context) \(action.description)" }
}


public extension FeatherPermission {

    var components: [String] { [namespace, context, action.description] }

    var accessIdentifier: String { (components + ["access"]).joined(separator: "-") }
}
