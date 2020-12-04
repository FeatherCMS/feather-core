//
//  Metadata.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

/// this object is a representation for frontend related pages with unique slugs
public final class FrontendMetadata: ViperModel {

    public typealias Module = FrontendModule

    public static let name = "metadatas"

    struct FieldKeys {
        /// reference
        static var module: FieldKey { "module" }
        static var model: FieldKey { "model" }
        static var reference: FieldKey { "reference" }

        /// metadata
        static var title: FieldKey { "title" }
        static var excerpt: FieldKey { "excerpt" }
        static var imageKey: FieldKey { "image_key" }
        static var date: FieldKey { "date" }

        /// seo
        static var slug: FieldKey { "slug" }
        static var status: FieldKey { "status" }
        static var feedItem: FieldKey { "feed_item" }
        static var canonicalUrl: FieldKey { "canonical_url" }

        /// content
        static var filters: FieldKey { "filters" }
        static var css: FieldKey { "css" }
        static var js: FieldKey { "js" }
    }
    
    // MARK: - fields
    
    /// status of the public page
    public enum Status: String, CaseIterable, Codable, FormFieldOptionRepresentable {
        /// drafts can be shared via direct urls, but not indexed by robots
        case draft
        /// published articles can be indexed and they are visible for everyone
        case published
        /// archives are not visible nor indexed
        case archived
        
        public var localized: String { rawValue.capitalized }

        public var formFieldOption: FormFieldOption {
            .init(key: rawValue, label: localized)
        }
    }
    
    /// unique identifier
    @ID() public var id: UUID?
    /// referenced module name
    @Field(key: FieldKeys.module) public var module: String
    /// referenced model name
    @Field(key: FieldKeys.model) public var model: String
    /// referenced model unique identifier
    @Field(key: FieldKeys.reference) public var reference: UUID
    
    /// seo title of the page, also used for metatags
    @Field(key: FieldKeys.title) public var title: String?
    /// seo / meta description of the content
    @Field(key: FieldKeys.excerpt) public var excerpt: String?
    /// preview image for the content
    @Field(key: FieldKeys.imageKey) public var imageKey: String?
    /// publish date
    @Field(key: FieldKeys.date) public var date: Date
    
    /// unique slug / seo friendly url
    @Field(key: FieldKeys.slug) public var slug: String
    /// status of the content
    @Field(key: FieldKeys.status) public var status: Status
    /// is the content included in feeds such as RSS
    @Field(key: FieldKeys.feedItem) public var feedItem: Bool
    /// canonical url of the content if there is one
    @Field(key: FieldKeys.canonicalUrl) public var canonicalUrl: String?
    
    /// the list of content filter identifiers that will be applied to the content during rendering
    @Field(key: FieldKeys.filters) public var filters: [String]
    /// custom stylesheet for the content
    @Field(key: FieldKeys.css) public var css: String?
    /// custom javascript for the content
    @Field(key: FieldKeys.js) public var js: String?

    public init() { }
    
    public init(id: UUID? = nil,
                module: String,
                model: String,
                reference: UUID,
                
                title: String? = nil,
                excerpt: String? = nil,
                imageKey: String? = nil,
                date: Date = Date(),
                
                slug: String,
                status: Status = .draft,
                feedItem: Bool = false,
                canonicalUrl: String? = nil,

                filters: [String] = [],
                css: String? = nil,
                js: String? = nil)
    {
        self.id = id
        self.module = module
        self.model = model
        self.reference = reference
        
        self.title = title
        self.excerpt = excerpt
        self.imageKey = imageKey
        self.date = date
        
        self.slug = slug
        self.status = status
        self.feedItem = feedItem
        self.canonicalUrl = canonicalUrl
        
        self.filters = filters
        self.css = css
        self.js = js
    }
}

