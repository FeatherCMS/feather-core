//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 02..
//

import Foundation

public struct MenuContext {
    public let key: String
    public let name: String
    public let items: [LinkContext]
    
    public init(key: String, name: String, items: [LinkContext]) {
        self.key = key
        self.name = name
        self.items = items
    }
}
