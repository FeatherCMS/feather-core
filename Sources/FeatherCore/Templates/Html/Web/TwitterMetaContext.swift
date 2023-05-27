//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 01..
//


public struct TwitterMetaContext {

    public let title: String
    public let excerpt: String?
    public let imageUrl: String?
    
    public init(title: String, excerpt: String?, imageUrl: String?) {
        self.title = title
        self.excerpt = excerpt
        self.imageUrl = imageUrl
    }
}
