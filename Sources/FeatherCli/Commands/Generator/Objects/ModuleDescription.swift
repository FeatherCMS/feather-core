//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 27..
//

import Foundation

struct ModuleDescription {
    
    let name: String
    let author: String
    let date: Date

    var models: [ModelDescription]
    
    
    var key: String { name.lowercased() }
}
