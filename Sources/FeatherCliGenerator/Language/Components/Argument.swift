//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 01..
//

import Foundation

class Argument {
    let name: String
    let type: String
    let label: String?
    
    init(name: String, type: String, label: String? = nil) {
        self.name = name
        self.type = type
        self.label = label
    }
}

extension Argument: CustomDebugStringConvertible {
    var debugDescription: String {
        var res = ""
        if let label = label {
            res = label + " "
        }
        return res + name + ": " + type
    }
}
