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
        case text
        case textarea
        case content
        case selection
        case multiselection
        case toggle
        case checkbox
        case radio
        case file
        case image
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

