//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

public struct TextareaFieldContext {
    
    public enum Size: String {
        case xs
        case s
        case normal
        case l
        case xl
    }
    
    public let key: String
    public var label: LabelContext
    public var size: Size
    public var placeholder: String?
    public var value: String?
    public var error: String?
    
    public init(key: String,
                label: LabelContext? = nil,
                size: Size = .normal,
                placeholder: String? = nil,
                value: String? = nil,
                error: String? = nil) {
        self.key = key
        self.label = label ?? .init(key: key)
        self.size = size
        self.placeholder = placeholder
        self.value = value
        self.error = error
    }
}
