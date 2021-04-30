//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 03. 30..
//

public struct TableColumn: Encodable {

    public let id: String
    public let label: String?
    
    public init(id: String, label: String? = nil) {
        self.id = id
        self.label = label ?? id.uppercasedFirst
    }
}

extension TableColumn: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(id: value, label: nil)
    }
}
