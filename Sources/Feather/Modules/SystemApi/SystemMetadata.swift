//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

public extension System {
    
    struct Metadata: FeatherApiModel {
        public typealias Module = System
    }
}

public extension System.Metadata {
    
    // MARK: -
    
    struct List: Codable {
        public var id: UUID
        public var module: String
        public var model: String
        public var reference: UUID
        public var slug: String
        public var title: String?
        public var excerpt: String?
        public var imageKey: String?
        public var date: Date
        public var status: FeatherMetadata.Status
        public var feedItem: Bool
        public var canonicalUrl: String?
        public var filters: [String]
        public var css: String?
        public var js: String?
        
        public init(id: UUID,
                    module: String,
                    model: String,
                    reference: UUID,
                    slug: String,
                    title: String? = nil,
                    excerpt: String? = nil,
                    imageKey: String? = nil,
                    date: Date,
                    status: FeatherMetadata.Status,
                    feedItem: Bool,
                    canonicalUrl: String? = nil,
                    filters: [String],
                    css: String? = nil,
                    js: String? = nil) {
            self.id = id
            self.module = module
            self.model = model
            self.reference = reference
            self.slug = slug
            self.title = title
            self.excerpt = excerpt
            self.imageKey = imageKey
            self.date = date
            self.status = status
            self.feedItem = feedItem
            self.canonicalUrl = canonicalUrl
            self.filters = filters
            self.css = css
            self.js = js
        }
    }
    
    // MARK: -
    
    struct Detail: Codable {
        public var id: UUID
        public var module: String
        public var model: String
        public var reference: UUID
        public var slug: String
        public var title: String?
        public var excerpt: String?
        public var imageKey: String?
        public var date: Date
        public var status: FeatherMetadata.Status
        public var feedItem: Bool
        public var canonicalUrl: String?
        public var filters: [String]
        public var css: String?
        public var js: String?
        
        public init(id: UUID,
                    module: String,
                    model: String,
                    reference: UUID,
                    slug: String,
                    title: String? = nil,
                    excerpt: String? = nil,
                    imageKey: String? = nil,
                    date: Date,
                    status: FeatherMetadata.Status,
                    feedItem: Bool,
                    canonicalUrl: String? = nil,
                    filters: [String],
                    css: String? = nil,
                    js: String? = nil) {
            self.id = id
            self.module = module
            self.model = model
            self.reference = reference
            self.slug = slug
            self.title = title
            self.excerpt = excerpt
            self.imageKey = imageKey
            self.date = date
            self.status = status
            self.feedItem = feedItem
            self.canonicalUrl = canonicalUrl
            self.filters = filters
            self.css = css
            self.js = js
        }
    }
    
    // MARK: -
    
    struct Update: Codable {
        public var slug: String
        public var title: String?
        public var excerpt: String?
        public var imageKey: String?
        public var date: Date
        public var status: FeatherMetadata.Status
        public var feedItem: Bool
        public var canonicalUrl: String?
        public var filters: [String]
        public var css: String?
        public var js: String?
        
        public init(slug: String,
                    title: String? = nil,
                    excerpt: String? = nil,
                    imageKey: String? = nil,
                    date: Date,
                    status: FeatherMetadata.Status,
                    feedItem: Bool,
                    canonicalUrl: String? = nil,
                    filters: [String],
                    css: String? = nil,
                    js: String? = nil) {
            self.slug = slug
            self.title = title
            self.excerpt = excerpt
            self.imageKey = imageKey
            self.date = date
            self.status = status
            self.feedItem = feedItem
            self.canonicalUrl = canonicalUrl
            self.filters = filters
            self.css = css
            self.js = js
        }
    }
    
    // MARK: -
    
    struct Patch: Codable {
        public var slug: String?
        public var title: String?
        public var excerpt: String?
        public var imageKey: String?
        public var date: Date?
        public var status: FeatherMetadata.Status?
        public var feedItem: Bool?
        public var canonicalUrl: String?
        public var filters: [String]?
        public var css: String?
        public var js: String?
        
        public init(slug: String? = nil,
                    title: String? = nil,
                    excerpt: String? = nil,
                    imageKey: String? = nil,
                    date: Date? = nil,
                    status: FeatherMetadata.Status? = nil,
                    feedItem: Bool? = nil,
                    canonicalUrl: String? = nil,
                    filters: [String]? = nil,
                    css: String? = nil,
                    js: String? = nil) {
            self.slug = slug
            self.title = title
            self.excerpt = excerpt
            self.imageKey = imageKey
            self.date = date
            self.status = status
            self.feedItem = feedItem
            self.canonicalUrl = canonicalUrl
            self.filters = filters
            self.css = css
            self.js = js
        }
    }
}

