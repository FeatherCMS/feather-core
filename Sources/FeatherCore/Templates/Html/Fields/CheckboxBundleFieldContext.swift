//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

public struct CheckboxBundleFieldContext {
    
    public let key: String
    public var label: LabelContext
    public var options: [OptionBundleContext]
    public var values: [String]
    public var error: String?
    
    public init(key: String,
                label: LabelContext? = nil,
                options: [OptionBundleContext] = [],
                values: [String] = [],
                error: String? = nil) {
        self.key = key
        self.label = label ?? .init(key: key)
        self.options = options
        self.values = values
        self.error = error
    }
}
