//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

public struct TextareaFieldView: FormFieldView {
    
    public enum Size: String, Codable {
        case xs
        case s
        case normal
        case l
        case xl
    }
    
    public let type: FormFieldType = .textarea

    public var key: String
    public var required: Bool
    public var error: String?

    public var value: String?

    public var label: String?
    public var placeholder: String?
    public var more: String?
    
    public var size: Size
    
    public init(key: String,
                required: Bool = false,
                error: String? = nil,
                value: String? = nil,
                label: String? = nil,
                placeholder: String? = nil,
                more: String? = nil,
                size: Size = .normal) {
        self.key = key
        self.required = required
        self.error = error
        self.value = value
        self.label = label?.🦅
        self.placeholder = placeholder
        self.more = more
        self.size = size
    }
}

