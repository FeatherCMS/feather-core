//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 15..
//

public struct FormFieldOptionGroup: Encodable {
    public var name: String
    public var options: [FormFieldOption]
    
    public init(name: String, options: [FormFieldOption] = []) {
        self.name = name
        self.options = options
    }
}

