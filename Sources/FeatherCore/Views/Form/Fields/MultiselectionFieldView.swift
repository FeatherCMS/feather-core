//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

public struct MultiselectionFieldView: FormFieldView {

    public let type: FormFieldType = .multiselection

    public var key: String
    public var required: Bool
    public var error: String?

    public var values: [String]?

    public var options: [FormFieldOption]

    public var label: String?
    public var more: String?
}

