//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

public struct SelectionFieldView: FormFieldView {

    public let type: FormFieldType = .selection

    public var key: String
    public var required: Bool
    public var error: String?

    public var value: String?

    public var options: [FormFieldOption]

    public var label: String?
    public var more: String?
}

