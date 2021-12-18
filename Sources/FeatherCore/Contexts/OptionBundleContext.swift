//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Foundation

public struct OptionBundleContext {

    public var name: String
    public var groups: [OptionGroupContext]
    
    public init(name: String, groups: [OptionGroupContext] = []) {
        self.name = name
        self.groups = groups
    }
}
