//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

import SwiftHtml

public struct AdminModulePageContext {
    
    public let title: String
    public let tag: Tag
    
    public init(title: String, tag: Tag) {
        self.title = title
        self.tag = tag
    } 
}

