//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

public struct WebSitemapContext {

    public let items: [Web.Metadata.List]
    
    public init(items: [Web.Metadata.List]) {
        self.items = items
    }
}

