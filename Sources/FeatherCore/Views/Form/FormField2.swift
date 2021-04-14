//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 03. 29..
//

//open class FormField: Codable {
//
//    public enum `Type`: String, Codable {
//        case text
//        case checkbox
//        case checkmark
//        case file
//        case image
//        case hidden
//        case multiselection
//        case radio
//        case selection
//        case textarea
//        case submit
//    }
//
//    public let id: String
//    public let type: Type
//    public let required: Bool
//
//    public let label: String?
//    public let placeholder: String?
//    public let more: String?
//
//    public var error: String?
//    public var data: [String: Context]
//    
//    public init(id: String,
//                type: FormField.`Type` = .text,
//                required: Bool = true,
//                
//                label: String? = nil,
//                placeholder: String? = nil,
//                more: String? = nil,
//
//                error: String? = nil,
//                data: [String: Context] = [:]) {
//        self.id = id
//        self.type = type
//        self.required = required
//        
//        self.label = label ?? id.lowercased().capitalized
//        self.placeholder = placeholder
//        self.more = more
//        
//        self.error = error
//        self.data = data
//    }
//}
//
//
//
