//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Foundation

public struct WebMetadata {
    
    public enum Status: String, Codable, CaseIterable {
        case draft
        case published
        case archived
    }
    
    public let slug: String
    public let title: String?
    public let excerpt: String?
    public let date: Date
    
    public init(slug: String, title: String? = nil, excerpt: String? = nil, date: Date = .init()) {
        self.slug = slug
        self.title = title
        self.excerpt = excerpt
        self.date = date
    }
}
