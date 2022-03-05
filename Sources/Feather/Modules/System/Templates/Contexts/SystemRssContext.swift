//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

import FeatherApi

public struct SystemRssContext {

    public let items: [FeatherMetadata.List]
    
    public init(items: [FeatherMetadata.List]) {
        self.items = items
    }
}

