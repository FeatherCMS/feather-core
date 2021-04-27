//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 27..
//

import Foundation

struct PropertyDescription {

    enum FieldType: String, CaseIterable {
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
    let name: String
    let type: FieldType
    let isRequired: Bool
    let isSearchable: Bool
    let isOrderingAllowed: Bool
    let formFieldType: FormFieldType
    
    var swiftTypeValue: String {
        type.rawValue.capitalized + (isRequired ? "" : "?")
    }
}

