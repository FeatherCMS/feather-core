//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

public struct ToggleFieldView: FormFieldView {
    
    public let type: FormFieldType = .toggle

    public var key: String
    public var required: Bool
    public var error: String?

    public var value: Bool

    public var label: String?
    public var more: String?
    
    public init(key: String,
                required: Bool = false,
                error: String? = nil,
                value: Bool = false,
                label: String? = nil,
                more: String? = nil) {
        self.key = key
        self.required = required
        self.error = error
        self.value = value
        self.label = label
        self.more = more
    }
}

