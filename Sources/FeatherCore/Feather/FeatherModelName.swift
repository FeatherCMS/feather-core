//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

import Foundation

public struct FeatherModelName {
    
    private var pluralException: String?
    
    public let singular: String
    public var plural: String { pluralException ?? singular + "s" }

    public init(singular: String, plural exception: String? = nil) {
        self.singular = singular
        self.pluralException = exception
    }
}

extension FeatherModelName: ExpressibleByStringLiteral {

    public init(stringLiteral value: StringLiteralType) {
        self.init(singular: value)
    }
}
