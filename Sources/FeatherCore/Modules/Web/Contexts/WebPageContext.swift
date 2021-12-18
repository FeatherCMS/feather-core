//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 18..
//

import Foundation

public struct WebPageContext {
    public var index: WebIndexContext
    
    public var title: String
    public var content: String
    
    public init(index: WebIndexContext, title: String, content: String) {
        self.index = index
        self.title = title
        self.content = content
    }
}
