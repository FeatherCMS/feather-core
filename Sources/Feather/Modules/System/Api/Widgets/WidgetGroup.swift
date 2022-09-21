//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 09. 21..
//

import Foundation

public struct WidgetGroup {

    public let id: String
    public let title: String
    public let excerpt: String

    public init(id: String,
                title: String,
                excerpt: String) {
        self.id = id
        self.title = title
        self.excerpt = excerpt
    }
}
