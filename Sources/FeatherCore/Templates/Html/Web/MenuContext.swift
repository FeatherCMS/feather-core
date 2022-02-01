//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 01..
//

import SwiftHtml

public struct MenuContext {

    public let id: String
    public let icon: Tag
    public let items: [Tag]
    
    public init(id: String, icon: Tag, items: [Tag]) {
        self.id = id
        self.icon = icon
        self.items = items
    }
}
