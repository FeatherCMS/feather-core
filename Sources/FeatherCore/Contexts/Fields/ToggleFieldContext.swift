//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

public struct ToggleFieldContext {
    
    public let key: String
    public var label: LabelContext
    public var value: Bool
    public var error: String?
    
    public init(key: String,
                label: LabelContext? = nil,
                value: Bool = false,
                error: String? = nil) {
        self.key = key
        self.label = label ?? .init(key: key)
        self.value = value
        self.error = error
    }
}
