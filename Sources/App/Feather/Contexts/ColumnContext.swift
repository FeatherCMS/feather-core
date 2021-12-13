//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 28..
//

import Foundation

public struct ColumnContext {
    
    public let key: String
    public let label: String
    public let sortable: Bool
    public let isDefault: Bool

    public init(_ key: String, label: String? = nil, sortable: Bool = true, isDefault: Bool = false) {
        self.key = key
        self.label = label ?? key.uppercasedFirst
        self.sortable = sortable
        self.isDefault = isDefault
    }
}
