//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Foundation

public struct WebWelcomePageContext {
    public var index: WebIndexContext
    
    public var title: String
    public var message: String
    
    public init(index: WebIndexContext, title: String, message: String) {
        self.index = index
        self.title = title
        self.message = message
    }
}
