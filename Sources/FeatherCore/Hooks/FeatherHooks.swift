//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 22..
//

public enum FeatherHook {
    case name(String)
}

extension FeatherHook: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .name(value)
    }
}

extension FeatherHook: CustomStringConvertible {
    public var description: String {
        switch self {
        case .name(let name):
            return name
        }
    }
}
