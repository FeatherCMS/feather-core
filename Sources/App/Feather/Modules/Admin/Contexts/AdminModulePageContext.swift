//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

import Foundation

public struct AdminModulePageContext {

    public let title: String
    public let message: String
    public let links: [LinkContext]
    
    public init(title: String, message: String, links: [LinkContext]) {
        self.title = title
        self.message = message
        self.links = links
    }
}

