//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 01..
//

import Foundation


class Object {
 
    let type: String
    let name: String
    let inherits: [String]
    let typealiases: [Typealias]
    
    let properties: [Property]
    let functions: [Function]
    
    init(type: String,
         name: String,
         inherits: [String] = [],
         typealiases: [Typealias] = [],
         properties: [Property] = [],
         functions: [Function] = [])
    {
        self.type = type
        self.name = name
        self.inherits = inherits
        self.typealiases = typealiases
        self.properties = properties
        self.functions = functions
    }
}

extension Object: CustomDebugStringConvertible {
    
    var debugDescription: String {
        var res = type + " " + name
        if !inherits.isEmpty {
            res = res + ": " + inherits.joined(separator: ", ")
        }
        res += " {\n"
        if !typealiases.isEmpty {
            res += typealiases.map(\.debugDescription).mapJoinLines()
            res += "\n\n"
        }
        if !properties.isEmpty {
            res += properties.map(\.debugDescription).mapJoinLines()
            res += "\n\n"
        }
        if !functions.isEmpty {
            res += functions.map(\.debugDescription).mapJoinLines()
            res += "}\n"
        }
        return res
    }
}


