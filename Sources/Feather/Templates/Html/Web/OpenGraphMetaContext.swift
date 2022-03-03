//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 01..
//

public struct OpenGraphMetaContext {
    
    public let url: String
    public let title: String
    public let excerpt: String?
    public let imageUrl: String?
    
    public init(url: String, title: String, excerpt: String?, imageUrl: String?) {
        self.url = url
        self.title = title
        self.excerpt = excerpt
        self.imageUrl = imageUrl
    }
}
