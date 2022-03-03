//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

public struct SystemRssContext {

    public let items: [System.Metadata.List]
    
    public init(items: [System.Metadata.List]) {
        self.items = items
    }
}

