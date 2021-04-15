//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

public struct MultiSelectionFieldView: FormFieldView {

    public let type: FormFieldType = .multiselection

    public var key: String
    public var required: Bool
    public var error: String?

    public var values: [String]

    public var options: [FormFieldOption]

    public var label: String?
    public var more: String?
    
    public init(key: String,
                required: Bool = false,
                error: String? = nil,
                values: [String] = [],
                options: [FormFieldOption] = [],
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

