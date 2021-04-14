//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

import Foundation

public enum FormFieldType: String, Codable {
    case text
    case checkbox
    case checkmark
    case file
    case image
    case hidden
    case multiselection
    case radio
    case selection
    case textarea
//    case submit
}

public protocol FormFieldOutput: Encodable {
    var type: FormFieldType { get }

    var key: String { get }
    var required: Bool { get }
    var error: String? { get set }

}

public struct TextFieldOutput: FormFieldOutput {

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
