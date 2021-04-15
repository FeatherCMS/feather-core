//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 15..
//

public struct FormFieldMultiGroupOption: Encodable {

    public var name: String
    public var groups: [FormFieldOptionGroup]
    
    public init(name: String, groups: [FormFieldOptionGroup] = []) {
        self.name = name
        self.groups = groups
    }
}
