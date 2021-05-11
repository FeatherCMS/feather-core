//
//  Metadata.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

/// this object is a representation for frontend related pages with unique slugs
final class FrontendMetadataModel: FeatherModel {
    typealias Module = FrontendModule

    static let modelKey: String = "metadatas"
    static let name: FeatherModelName = "Metadata"

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
    @OptionalField(key: FieldKeys.title) var title: String?
    /// seo / meta excerpt of the content
    @OptionalField(key: FieldKeys.excerpt) var excerpt: String?
    /// preview image for the content
    @OptionalField(key: FieldKeys.imageKey) var imageKey: String?
    /// publish date
    @Field(key: FieldKeys.date) var date: Date
    /// is the content included in feeds such as RSS
    @Field(key: FieldKeys.feedItem) var feedItem: Bool
    /// canonical url of the content if there is one
    @OptionalField(key: FieldKeys.canonicalUrl) var canonicalUrl: String?
    /// custom stylesheet for the content
    @OptionalField(key: FieldKeys.css) var css: String?
    /// custom javascript for the content
    @OptionalField(key: FieldKeys.js) var js: String?

    /// the list of content filter identifiers that will be applied to the content during rendering
    @Field(key: FieldKeys.filters) var filters: [String]

    init() {
        date = Date()
        status = .draft
        feedItem = false
        filters = []
    }

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
    
    // MARK: - query

    static func allowedOrders() -> [FieldKey] {
        [
            FieldKeys.slug,
            FieldKeys.title,
        ]
    }
    
    static func search(_ term: String) -> [ModelValueFilter<FrontendMetadataModel>] {
        [
            \.$slug ~~ term,
            \.$title ~~ term,
        ]
    }
    
    // MARK: - info
    
    /// disable create & delete operations
    static func info(_ req: Request) -> ModelInfo {
        let list = req.checkPermission(for: permission(for: .list))
        let get = req.checkPermission(for: permission(for: .get))
        let create = false
        let update = req.checkPermission(for: permission(for: .update))
        let patch = req.checkPermission(for: permission(for: .patch))
        let delete = false
    
        let permissions = ModelInfo.AvailablePermissions(list: list, get: get, create: create, update: update, patch: patch, delete: delete)
        return ModelInfo(idKey: modelKey,
                         idParamKey: idParamKey,
                         name: .init(singular: name.singular, plural: name.plural),
                         assetPath: assetPath,
                         module: .init(idKey: Module.moduleKey, name: Module.name, assetPath: Module.assetPath),
                         permissions: permissions,
                         isSearchable: isSearchable,
                         allowedOrders: allowedOrders().map(\.description),
                         defaultOrder: allowedOrders().first?.description,
                         defaultSort: defaultSort().rawValue)
    }
}

// MARK: - view

extension Metadata.Status {

    public var formFieldOption: FormFieldOption {
        .init(key: rawValue, label: localized)
    }
}

// MARK: - metadata

extension FrontendMetadataModel {

    /// update the model using a metadata object, we never update the id
    func use(_ metadata: Metadata) {
        if let value = metadata.id { id = value }
        if let value = metadata.module { module = value }
        if let value = metadata.model { model = value }
        if let value = metadata.reference { reference = value }
        if let value = metadata.slug { slug = value }
        if let value = metadata.status { status = value }
        if let value = metadata.title { title = value }
        if let value = metadata.excerpt { excerpt = value }
        if let value = metadata.imageKey { imageKey = value }
        if let value = metadata.date { date = value }
        if let value = metadata.feedItem { feedItem = value }
        if let value = metadata.canonicalUrl { canonicalUrl = value }
        if let value = metadata.filters { filters = value }
        if let value = metadata.css { css = value }
        if let value = metadata.js { js = value }
    }

    var metadata: Metadata {
        .init(id: id,
              module: module,
              model: model,
              reference: reference,
              slug: slug,
              status: status,
              title: title,
              excerpt: excerpt,
              imageKey: imageKey,
              date: date,
              feedItem: feedItem,
              canonicalUrl: canonicalUrl,
              filters: filters,
              css: css,
              js: js)
    }
}

