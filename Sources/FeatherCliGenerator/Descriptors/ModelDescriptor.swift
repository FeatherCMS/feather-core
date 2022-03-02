//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 13..
//


public struct ModelDescriptor {
    public var name: String
    public var properties: [PropertyDescriptor]

    public init(name: String, properties: [PropertyDescriptor]) {
        self.name = name
        self.properties = properties
    }
}
