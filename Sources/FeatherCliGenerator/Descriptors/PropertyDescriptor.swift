//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 13..
//

public struct PropertyDescriptor {

    public enum DatabaseFieldType: String, CaseIterable {
        case string
        case int
        case double
        case bool
        case date
    }

    public enum FormFieldType: String, CaseIterable {
        case input
        case textarea
        case content
        case image
        case toggle
        case radio
        case checkbox
        case checkboxBundle
        case select
        case multipleSelect
        case file
        case multipleFile
        case hidden
//        case submit

        var fieldName: String {
            rawValue.capitalized + "Field"
        }
    }

    public let name: String
    public let databaseType: DatabaseFieldType
    public let formFieldType: FormFieldType
    public let isRequired: Bool
    public let isSearchable: Bool
    public let isOrderingAllowed: Bool

    public var swiftType: String {
        databaseType.rawValue.capitalized + (isRequired ? "" : "?")
    }
    
    public init(name: String,
                databaseType: PropertyDescriptor.DatabaseFieldType,
                formFieldType: PropertyDescriptor.FormFieldType,
                isRequired: Bool,
                isSearchable: Bool,
                isOrderingAllowed: Bool) {
        self.name = name
        self.databaseType = databaseType
        self.formFieldType = formFieldType
        self.isRequired = isRequired
        self.isSearchable = isSearchable
        self.isOrderingAllowed = isOrderingAllowed
    }
}

