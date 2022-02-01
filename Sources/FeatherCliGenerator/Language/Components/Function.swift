//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 01..
//

import Foundation

class Function {
    let name: String
    let arguments: [Argument]
    let returns: String?
    let body: String
    let access: Access
    let modifiers: [String]
    let wrappers: [String]
    
    init(name: String,
         arguments: [Argument] = [],
         returns: String? = nil,
         body: String,
         access: Access = .internal,
         modifiers: [String] = [],
         wrappers: [String] = []
    ) {
        self.name = name
        self.arguments = arguments
        self.returns = returns
        self.body = body
        self.access = access
        self.modifiers = modifiers
        self.wrappers = wrappers
    }
}

extension Function: CustomDebugStringConvertible {

    var debugDescription: String {
        var res = ""
        if !wrappers.isEmpty {
            res = res + wrappers.joined(separator: "\n") + "\n    "
        }
        res = res + access.debugDescription + "func "
        res += name
        res += "("
        res += arguments.map(\.debugDescription).joined(separator: ", ")
        res += ")"
        if !modifiers.isEmpty {
            res = res + " " + modifiers.joined(separator: " ")
        }
        if let ret = returns {
            res = res + " -> " + ret
        }
        res += " {\n"
        res += body.indentLines(2)
        res += "\n    }\n"
        return res
    }
}
