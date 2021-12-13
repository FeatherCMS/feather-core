//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Foundation

public struct CheckboxFieldContext {
    
    public let key: String
    public var label: LabelContext
    public var options: [OptionContext]
    public var values: [String]
    public var error: String?
    
    public init(key: String,
                label: LabelContext? = nil,
                options: [OptionContext] = [],
                values: [String] = [],
                error: String? = nil) {
        self.key = key
        self.label = label ?? .init(key: key)
        self.options = options
        self.values = values
        self.error = error
    }
    
    
}
