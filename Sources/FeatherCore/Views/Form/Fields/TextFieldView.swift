//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

public struct TextFieldView: FormFieldView {
    
    public let type: FormFieldType = .text

    public var key: String
    public var required: Bool
    public var error: String?

    public var value: String?

    public var label: String?
    public var placeholder: String?
    public var more: String?
    
    public var format: String? // email|password|number, etc.
}

