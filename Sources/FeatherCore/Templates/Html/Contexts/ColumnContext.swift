//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 28..
//

public struct ColumnContext {
    
    public let key: String
    public let label: String
    public let width: String?

    public init(_ key: String, label: String? = nil, width: String? = nil) {
        self.key = key
        self.label = label ?? key.capitalized
        self.width = width
    }
}
