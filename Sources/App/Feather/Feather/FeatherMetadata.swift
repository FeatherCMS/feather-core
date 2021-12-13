//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Foundation

public struct FeatherMetadata: Codable {
    
    public enum Status: String, CaseIterable, Codable {
        case draft
        case published
        case archived
    }

    public var id: UUID?
    public var module: String?
    public var model: String?
    public var reference: UUID?
    public var slug: String?
    public var status: Status?
    public var title: String?
    public var excerpt: String?
    public var imageKey: String?
    public var date: Date?
    public var feedItem: Bool?
    public var canonicalUrl: String?
    public var filters: [String]?
    public var css: String?
    public var js: String?
    
    public init(id: UUID? = nil,
                module: String? = nil,
                model: String? = nil,
                reference: UUID? = nil,
                slug: String? = nil,
                status: Status? = nil,
                title: String? = nil,
                excerpt: String? = nil,
                imageKey: String? = nil,
                date: Date? = nil,
                feedItem: Bool? = nil,
                canonicalUrl: String? = nil,
                filters: [String]? = nil,
                css: String? = nil,
                js: String? = nil)
    {
        self.id = id
        self.model = model
        self.module = module
        self.reference = reference
        self.slug = slug
        self.status = status
        self.title = title
        self.excerpt = excerpt
        self.imageKey = imageKey
        self.date = date
        self.feedItem = feedItem
        self.canonicalUrl = canonicalUrl
        self.filters = filters
        self.css = css
        self.js = js
    }
}

