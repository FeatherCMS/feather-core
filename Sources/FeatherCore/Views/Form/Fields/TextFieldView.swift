//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

public struct TextFieldView: FormFieldView {
    
    public enum Format: String, Codable {
        case normal
        case secure
        case email
        case number
    }
    
    public let type: FormFieldType = .text

    public var key: String
    public var required: Bool
    public var error: String?

    public var value: String?

    public var label: String?
    public var placeholder: String?
    public var more: String?
    
    public var format: Format
    
    public init(key: String,
                required: Bool = false,
                error: String? = nil,
                value: String? = nil,
                label: String? = nil,
                placeholder: String? = nil,
                more: String? = nil,
                format: Format = .normal) {
        self.key = key
        self.required = required
        self.error = error
        self.value = value
        self.label = label
        self.placeholder = placeholder
        self.more = more
        self.format = format
    }
}

