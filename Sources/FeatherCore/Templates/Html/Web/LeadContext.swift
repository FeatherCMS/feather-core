//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 01..
//

public struct LeadContext {

    public let icon: String?
    public let title: String
    public let excerpt: String?
    public let links: [LinkContext]
    
    public init(icon: String? = nil,
                title: String,
                excerpt: String? = nil,
                links: [LinkContext] = []) {
        self.icon = icon
        self.title = title
        self.excerpt = excerpt
        self.links = links
    }
}
