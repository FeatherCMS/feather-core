//
//  HeadContext.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 08. 23..
//

import Foundation

/// a basic head context for rendering frontend pages  
public struct HeadContext: Encodable {

    /// title of the page
    public var title: String?
    /// short meta description
    public var excerpt: String?
    /// image key used to display the page
    public var imageKey: String?
    /// canonical url
    public var canonicalUrl: String?
    /// should the page indexed by search engines
    public var indexed: Bool

    public init(title: String? = nil,
                excerpt: String? = nil,
                imageKey: String? = nil,
                canonicalUrl: String? = nil,
                indexed: Bool = true)
    {
        self.title = title
        self.excerpt = excerpt
        self.imageKey = imageKey
        self.canonicalUrl = canonicalUrl
        self.indexed = indexed
    }
}
