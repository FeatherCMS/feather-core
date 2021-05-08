//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 27..
//

public struct ContentFieldView: FormFieldView {
    
    public let type: FormFieldType = .content

    public var key: String
    public var required: Bool
    public var error: String?

    public var value: String?

    public var label: String?
    public var placeholder: String?
    public var more: String?
        
    public init(key: String,
                required: Bool = false,
                error: String? = nil,
                value: String? = nil,
                label: String? = nil,
                placeholder: String? = nil,
                more: String? = nil) {
        self.key = key
        self.required = required
        self.error = error
        self.value = value
        self.label = label?.🦅
        self.placeholder = placeholder
        self.more = more
    }
}

