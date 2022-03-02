//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 01..
//

import Foundation

class Property {
    let constant: Bool
    let name: String
    let type: String
    let value: String?
    let getter: String?
    let setter: String?
    let access: Access
    
    init(constant: Bool = false,
         name: String,
         type: String,
         value: String? = nil,
         getter: String? = nil,
         setter: String? = nil,
         access: Access = .internal) {
        self.constant = constant
        self.name = name
        self.type = type
        self.value = value
        self.getter = getter
        self.setter = setter
        self.access = access
    }
    
    var hasBody: Bool { getter != nil || setter != nil }
}

extension Property: CustomDebugStringConvertible {
    var debugDescription: String {
        var res = access.debugDescription + (constant ? "let" : "var") + " " + name + ": " + type
        if hasBody {
            res += " {\n"
        }
        if let getter = getter {
            if setter != nil {
                res += "get {\n"
                res += getter.indentLines(3)
                res += "\n        }\n"
            }
            else {
                res += getter.indentLines(2)
            }
        }
        if let setter = setter {
            res += "set {\n"
            res += setter.indentLines(3)
            res += "\n        }\n"
        }
        if hasBody {
            res += "\n    }"
        }
        return res
    }
}
