//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

public struct OptionGroupContext {
    
    public var name: String
    public var options: [OptionContext]
    
    public init(name: String, options: [OptionContext] = []) {
        self.name = name
        self.options = options
    }
}

