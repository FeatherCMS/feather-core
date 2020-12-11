//
//  Metadata.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

/// this object is a representation for frontend related pages with unique slugs
final class FrontendMetadataModel: ViperModel {
    typealias Module = FrontendModule

    static let name = "metadatas"

    struct FieldKeys {
        /// reference
        static var module: FieldKey { "module" }
        static var model: FieldKey { "model" }
        static var reference: FieldKey { "reference" }

        /// public
        static var slug: FieldKey { "slug" }
        static var status: FieldKey { "status" }
        static var title: FieldKey { "title" }
        static var excerpt: FieldKey { "excerpt" }
        static var imageKey: FieldKey { "image_key" }
        static var date: FieldKey { "date" }
        static var feedItem: FieldKey { "feed_item" }
        static var canonicalUrl: FieldKey { "canonical_url" }
        static var css: FieldKey { "css" }
        static var js: FieldKey { "js" }

        /// private
        static var filters: FieldKey { "filters" }
        
    }
    
    // MARK: - fields

    /// unique identifier
    @ID() var id: UUID?
    /// referenced module name
    @Field(key: FieldKeys.module) var module: String
    /// referenced model name
    @Field(key: FieldKeys.model) var model: String
    /// referenced model unique identifier
    @Field(key: FieldKeys.reference) var reference: UUID
    
    /// unique slug / seo friendly url
    @Field(key: FieldKeys.slug) var slug: String
    /// status of the content
    @Field(key: FieldKeys.status) var status: Metadata.Status
    /// seo title of the page, also used for metatags
    @Field(key: FieldKeys.title) var title: String?
    /// seo / meta description of the content
    @Field(key: FieldKeys.excerpt) var excerpt: String?
    /// preview image for the content
    @Field(key: FieldKeys.imageKey) var imageKey: String?
    /// publish date
    @Field(key: FieldKeys.date) var date: Date
    /// is the content included in feeds such as RSS
    @Field(key: FieldKeys.feedItem) var feedItem: Bool
    /// canonical url of the content if there is one
    @Field(key: FieldKeys.canonicalUrl) var canonicalUrl: String?
    /// custom stylesheet for the content
    @Field(key: FieldKeys.css) var css: String?
    /// custom javascript for the content
    @Field(key: FieldKeys.js) var js: String?

    /// the list of content filter identifiers that will be applied to the content during rendering
    @Field(key: FieldKeys.filters) var filters: [String]

    init() { }
    
    init(id: UUID? = nil,
         module: String,
         model: String,
         reference: UUID,
         
         slug: String,
         status: Metadata.Status = .draft,
         title: String? = nil,
         excerpt: String? = nil,
         imageKey: String? = nil,
         date: Date = Date(),
         feedItem: Bool = false,
         canonicalUrl: String? = nil,
         css: String? = nil,
         js: String? = nil,
         
         filters: [String] = [])
    {
        self.id = id
        self.module = module
        self.model = model
        self.reference = reference
        
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

        self.filters = filters
    }
}

