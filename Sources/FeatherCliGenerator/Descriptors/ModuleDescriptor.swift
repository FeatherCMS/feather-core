//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 13..
//

import Foundation

public struct ModuleDescriptor {
    public let name: String
    public var models: [ModelDescriptor]
    
    public init(name: String, models: [ModelDescriptor]) {
        self.name = name
        self.models = models
    }
    
}
