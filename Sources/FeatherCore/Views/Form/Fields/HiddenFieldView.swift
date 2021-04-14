//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

public struct HiddenFieldView: FormFieldView {
    
    public let type: FormFieldType = .hidden

    public var key: String
    public var required: Bool
    public var error: String?

    public var value: String?
    
    public init(key: String,
                required: Bool = false,
                error: String? = nil,
                value: String? = nil) {
        self.key = key
        self.required = required
        self.error = error
        self.value = value
    }
}

