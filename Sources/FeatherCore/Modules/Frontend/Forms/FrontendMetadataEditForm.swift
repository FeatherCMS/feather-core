//
//  FrontendContentEditForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

final class FrontendMetadataEditForm: ModelForm {
    typealias Model = FrontendMetadata
    
    struct Input: Decodable {
        var modelId: UUID
        var module: String
        var model: String
        var reference: UUID
        var slug: String
        var title: String
        var excerpt: String
        var canonicalUrl: String
        var statusId: String
        var filters: [String]
        var date: String
        var feedItem: Bool
        var css: String
        var js: String
        var image: File?
        var imageDelete: Bool?
    }

    var modelId: UUID?
    var module = FormField<String>(key: "module").required().length(max: 250)
    var model = FormField<String>(key: "model").required().length(max: 250)
    var reference = FormField<UUID>(key: "reference")
    var slug = FormField<String>(key: "slug").required().length(max: 250)
    var title = FormField<String>(key: "title").length(max: 250)
    var excerpt = FormField<String>(key: "excerpt").length(max: 250)
    var canonicalUrl = FormField<String>(key: "canonicalUrl").length(max: 250)
    var statusId = SelectionFormField<String>(key: "statusId")
    var feedItem = SelectionFormField<Bool>(key: "feedItem")
    var filters = FormField<[String]>(key: "filters")
    var date = FormField<String>(key: "date")
    var image = FormField<FileUploadValue>(key: "image")
    var css = FormField<String>(key: "css")
    var js = FormField<String>(key: "js")
    var notification: String?

    var dateFormat: String?
    
    var fields: [AbstractFormField] {
        [module, model, reference, slug, title, excerpt, canonicalUrl, statusId, feedItem, filters, date, image, css, js]
    }

    init() {}

    func initialize(req: Request) -> EventLoopFuture<Void> {
        dateFormat = Application.Config.dateFormatter().dateFormat
        statusId.options = Model.Status.allCases.map(\.formFieldOption)
        statusId.value = Model.Status.draft.rawValue
        date.value = Application.Config.dateFormatter().string(from: Date())
        feedItem.options = FormFieldOption.trueFalse()
        return req.eventLoop.future()
    }
    
    func processInput(req: Request) throws -> EventLoopFuture<Void> {
        let context = try req.content.decode(Input.self)
        modelId = context.modelId
        module.value = context.module
        model.value = context.model
        reference.value = context.reference
        slug.value = context.slug
        statusId.value = context.statusId
        filters.value = context.filters
        date.value = context.date
        title.value = context.title
        excerpt.value = context.excerpt
        canonicalUrl.value = context.canonicalUrl
        feedItem.value = context.feedItem
        css.value = context.css
        js.value = context.js

//        image.delete = context.imageDelete ?? false
//        if let img = context.image, let data = img.data.getData(at: 0, length: img.data.readableBytes), !data.isEmpty {
//            image.data = data
//        }

        return req.eventLoop.future()
    }

    func read(from input: Model)  {
        modelId = input.id
        module.value = input.module
        model.value = input.model
        reference.value = input.reference
        slug.value = input.slug
        statusId.value = input.status.rawValue
        feedItem.value = input.feedItem
        filters.value = input.filters
        date.value = Application.Config.dateFormatter().string(from: input.date)
        title.value = input.title
        excerpt.value = input.excerpt
        canonicalUrl.value = input.canonicalUrl
//        image.value = input.imageKey
        css.value = input.css
        js.value = input.js
    }

    func write(to output: Model) {
        output.module = module.value!
        output.model = model.value!
        output.reference = reference.value!
        output.slug = slug.value!
        output.status = Model.Status(rawValue: statusId.value!)!
        output.feedItem = feedItem.value!
        output.filters = filters.value ?? []
        output.date = Application.Config.dateFormatter().date(from: date.value!)!
        output.title = title.value?.emptyToNil
        output.excerpt = excerpt.value?.emptyToNil
        output.canonicalUrl = canonicalUrl.value?.emptyToNil
        output.css = css.value?.emptyToNil
        output.js = js.value?.emptyToNil
    }
}
