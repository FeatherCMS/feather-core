//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

import Foundation

public struct WebMenuContext {
    public let key: String
    public let children: [LinkContext]

    public init(key: String, children: [LinkContext]) {
        self.key = key
        self.children = children
    }
}
