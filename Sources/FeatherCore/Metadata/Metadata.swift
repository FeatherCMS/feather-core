//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//


public struct Metadata: LeafDataRepresentable {
    
    public enum Status: String, CaseIterable, Codable {
        case draft
        /// published articles can be indexed and they are visible for everyone
        case published
        /// archives are not visible nor indexed
        case archived
 
        public var localized: String { rawValue.capitalized }
    }

    public var id: UUID?
    public var slug: String
    public var status: Status?
    public var title: String?
    public var excerpt: String?
    public var imageKey: String?
    public var date: Date?
    public var feedItem: Bool?
    public var canonicalUrl: String?
    public var css: String?
    public var js: String?
    
    public init(id: UUID? = nil,
                slug: String,
                status: Metadata.Status? = nil,
                title: String? = nil,
                excerpt: String? = nil,
                imageKey: String? = nil,
                date: Date? = nil,
                feedItem: Bool? = nil,
                canonicalUrl: String? = nil,
                css: String? = nil,
                js: String? = nil)
    {
        self.id = id
        self.slug = slug
        self.status = status
        self.title = title
        self.excerpt = excerpt
        self.imageKey = imageKey
        self.date = date
        self.feedItem = feedItem
        self.canonicalUrl = canonicalUrl
        self.css = css
        self.js = js
    }
    
    
    public var leafData: LeafData {
        .dictionary([
            "id": id,
            "slug": slug,
            "status": status?.encodeToLeafData(),
            "title": title,
            "excerpt": excerpt,
            "imageKey": imageKey,
            "date": date,
            "feedItem": feedItem,
            "canonicalUrl": canonicalUrl,
            "css": css,
            "js": js,
        ])
    }
}

extension FrontendMetadataModel {

    /// update the model using a metadata object, we never update the id
    func use(_ metadata: Metadata, updateSlug: Bool) {
        if updateSlug {
            slug = metadata.slug
        }
        status = metadata.status ?? status
        title = metadata.title ?? title
        excerpt = metadata.excerpt ?? excerpt
        imageKey = metadata.imageKey ?? imageKey
        date = metadata.date ?? date
        feedItem = metadata.feedItem ?? feedItem
        canonicalUrl = metadata.canonicalUrl ?? canonicalUrl
        css = metadata.css ?? css
        js = metadata.js ?? js
    }

    var metadata: Metadata {
        .init(id: id,
              slug: slug,
              status: status,
              title: title,
              excerpt: excerpt,
              imageKey: imageKey,
              date: date,
              feedItem: feedItem,
              canonicalUrl: canonicalUrl,
              css: css,
              js: js)
    }
}

