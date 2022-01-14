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
        case bool
    }

    public enum FormFieldType: String, CaseIterable {
        case checkboxBundle
        case checkbox
        case content
        case file
        case hidden
        case image
        case input
        case multipleFile
        case multipleSelect
        case radio
        case select
//        case submit
        case textarea
        case toggle
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

