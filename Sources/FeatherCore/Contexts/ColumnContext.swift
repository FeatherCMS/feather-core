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

    public init(_ key: String, label: String? = nil) {
        self.key = key
        self.label = label ?? key.uppercasedFirst
    }
}
