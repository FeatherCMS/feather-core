//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 01..
//

public struct LeadContext {

    public let title: String
    public let excerpt: String
    public let icon: String?
    
    public init(title: String, excerpt: String, icon: String?) {
        self.title = title
        self.excerpt = excerpt
        self.icon = icon
    }
}
