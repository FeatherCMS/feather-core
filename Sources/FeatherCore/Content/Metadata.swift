//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

public final class Metadata: Model {

    public static let schema = "_feather_metadata"

    struct FieldKeys {
        static var module: FieldKey { "module" }
        static var model: FieldKey { "model" }
        static var reference: FieldKey { "reference" }

        static var slug: FieldKey { "slug" }
        static var date: FieldKey { "date" }
        static var status: FieldKey { "status" }
        static var filters: FieldKey { "filters" }
        static var feedItem: FieldKey { "feedItem" }

        static var title: FieldKey { "title" }
        static var excerpt: FieldKey { "excerpt" }
        static var imageKey: FieldKey { "image_key" }
        static var canonicalUrl: FieldKey { "canonical_url" }
    }
    
    // MARK: - fields
    
    public enum Status: String, CaseIterable, Codable, FormFieldOptionRepresentable {
        case draft
        case published
        case archived
        
        public var localized: String {
            self.rawValue.capitalized
        }

        public var formFieldOption: FormFieldOption {
            .init(key: self.rawValue, label: self.localized)
        }
    }
    
    @ID() public var id: UUID?
    @Field(key: FieldKeys.module) public var module: String
    @Field(key: FieldKeys.model) public var model: String
    @Field(key: FieldKeys.reference) public var reference: UUID
    
    
    @Field(key: FieldKeys.slug) public var slug: String
    @Field(key: FieldKeys.date) public var date: Date
    @Field(key: FieldKeys.status) public var status: Status
    @Field(key: FieldKeys.filters) public var filters: [String]
    @Field(key: FieldKeys.feedItem) public var feedItem: Bool

    @Field(key: FieldKeys.title) public var title: String?
    @Field(key: FieldKeys.excerpt) public var excerpt: String?
    @Field(key: FieldKeys.imageKey) public var imageKey: String?
    @Field(key: FieldKeys.canonicalUrl) public var canonicalUrl: String?

    public init() { }
    
    public init(id: UUID? = nil,
                module: String,
                model: String,
                reference: UUID,
                slug: String,
                date: Date = Date(),
                status: Status = .draft,
                filters: [String] = [],
                feedItem: Bool = false,
                title: String? = nil,
                excerpt: String? = nil,
                imageKey: String? = nil,
                canonicalUrl: String? = nil)
    {
        self.id = id
        self.module = module
        self.model = model
        self.reference = reference
        self.slug = slug
        self.date = date
        self.status = status
        self.filters = filters
        self.feedItem = feedItem
        self.title = title
        self.excerpt = excerpt
        self.imageKey = imageKey
        self.canonicalUrl = canonicalUrl
    }
}

