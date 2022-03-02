//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 01..
//

import Foundation

class Typealias {

    let name: String
    let value: String
    let access: Access
    
    init(name: String,
         value: String,
         access: Access = .internal) {
        self.name = name
        self.value = value
        self.access = access
    }
}

extension Typealias: CustomDebugStringConvertible {
    var debugDescription: String {
        access.debugDescription + "typealias " + name + " = " + value
    }
}
