//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Foundation

public struct OptionGroupContext {
    
    public let name: String
    public let options: [OptionContext]
    
    public init(name: String, options: [OptionContext] = []) {
        self.name = name
        self.options = options
    }
}

