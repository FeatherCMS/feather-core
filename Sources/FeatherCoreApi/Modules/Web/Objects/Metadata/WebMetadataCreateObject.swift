//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Foundation

extension WebMetadata {

    public struct Create: Codable {
        public var slug: String
        public var title: String?
        public var excerpt: String?
        public var imageKey: String?
        public var date: Date
        public var status: WebMetadata.Status
        public var feedItem: Bool
        public var canonicalUrl: String?
        public var filters: [String]
        public var css: String?
        public var js: String?
        
        public init(slug: String,
                    title: String? = nil,
                    excerpt: String? = nil,
                    imageKey: String? = nil,
                    date: Date = .init(),
                    status: WebMetadata.Status = .draft,
                    feedItem: Bool = false,
                    canonicalUrl: String? = nil,
                    filters: [String] = [],
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
