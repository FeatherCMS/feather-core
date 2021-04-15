//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 15..
//

public struct MultiGroupOptionFieldView: FormFieldView {

    public let type: FormFieldType = .multigroupoption

    public var key: String
    public var required: Bool
    public var error: String?

    public var values: [String]

    public var options: [FormFieldMultiGroupOption]

    public var label: String?
    public var more: String?
    
    public init(key: String,
                required: Bool = false,
                error: String? = nil,
                values: [String] = [],
                options: [FormFieldMultiGroupOption] = [],
                label: String? = nil,
                more: String? = nil) {
        self.key = key
        self.required = required
        self.error = error
        self.values = values
        self.options = options
        self.label = label
        self.more = more
    }
}

