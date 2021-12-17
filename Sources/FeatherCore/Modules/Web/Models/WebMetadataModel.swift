//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor
import Fluent

final class WebMetadataModel: FeatherModel {
    typealias Module = WebModule

    struct FieldKeys {
        struct v1 {
            static var module: FieldKey { "module" }
            static var model: FieldKey { "model" }
            static var reference: FieldKey { "reference" }
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
            static var filters: FieldKey { "filters" }
        }
    }

    @ID() var id: UUID?
    @Field(key: FieldKeys.v1.module) var module: String
    @Field(key: FieldKeys.v1.model) var model: String
    @Field(key: FieldKeys.v1.reference) var reference: UUID
    @Field(key: FieldKeys.v1.slug) var slug: String
    @Field(key: FieldKeys.v1.status) var status: FeatherMetadata.Status
    @Field(key: FieldKeys.v1.title) var title: String?
    @Field(key: FieldKeys.v1.excerpt) var excerpt: String?
    @Field(key: FieldKeys.v1.imageKey) var imageKey: String?
    @Field(key: FieldKeys.v1.date) var date: Date
    @Field(key: FieldKeys.v1.feedItem) var feedItem: Bool
    @Field(key: FieldKeys.v1.canonicalUrl) var canonicalUrl: String?
    @Field(key: FieldKeys.v1.css) var css: String?
    @Field(key: FieldKeys.v1.js) var js: String?
    @Field(key: FieldKeys.v1.filters) var filters: [String]

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
         status: FeatherMetadata.Status = .draft,
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

