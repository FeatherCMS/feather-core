//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 28..
//

import Foundation

public struct FieldContext {

    public enum `Type`: String {
        case text
        case image
    }

    public let label: String
    public let value: String?
    public let type: `Type`
    
    public init(label: String, value: String?, type: `Type` = .text) {
        self.label = label
        self.value = value
        self.type = type
    }
}
