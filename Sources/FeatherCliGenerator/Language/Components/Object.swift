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
    let generateInit: Bool
    
    init(type: String,
         name: String,
         inherits: [String] = [],
         typealiases: [Typealias] = [],
         properties: [Property] = [],
         functions: [Function] = [],
         generateInit: Bool = false)
    {
        self.type = type
        self.name = name
        self.inherits = inherits
        self.typealiases = typealiases
        self.properties = properties
        self.functions = functions
        self.generateInit = generateInit
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
        
        if generateInit {
            let props = properties.map { prop -> String in
                var ret = prop.name + ": " + prop.type
                if let value = prop.value {
                    ret = ret + " = " + value
                }
                return ret
            }.joined(separator: ",\n")
            let propsInit = properties.map { "self." + $0.name + " = " + $0.name }.joined(separator: "\n")
            
            res = res + """
            init(
            \(props.indentLines())
            ) {
            \(propsInit.indentLines())
            }
            """.indentLines() + "\n"
        }
        
        if !functions.isEmpty {
            res += functions.map(\.debugDescription).mapJoinLines()
        }
        res += "}\n"
        return res
    }
}


