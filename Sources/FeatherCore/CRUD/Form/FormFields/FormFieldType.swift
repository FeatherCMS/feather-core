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
