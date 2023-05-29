//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

public enum HookName {
    case name(String)
}

extension HookName: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .name(value)
    }
}

extension HookName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .name(let name):
            return name
        }
    }
}
