//
//  FrontendContentEditForm.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

final class SystemMetadataEditForm: EditForm {
    typealias Model = SystemMetadataModel

    var modelId: UUID?
//    var module = TextField(key: "module").required().length(max: 250)
//    var model = TextField(key: "model").required().length(max: 250)
//    var reference = TextField(key: "reference")
    var slug = TextField(key: "slug")
    var title = TextField(key: "title")
    var excerpt = TextField(key: "excerpt")
    var canonicalUrl = TextField(key: "canonicalUrl")
    var statusId = SelectionField(key: "statusId")
    var feedItem = ToggleField(key: "feedItem")
    var filters = MultiSelectionField(key: "filters")
    var date = TextField(key: "date")
    var css = TextareaField(key: "css")
    var js = TextareaField(key: "js")
//    var image = FileFormField(key: "image")
    var notification: String?

    var dateFormat: String?
    
    var fields: [FormFieldRepresentable] {
        [slug, title, excerpt, canonicalUrl, statusId, feedItem, filters, date, /*image,*/ css, js]
    }

    init() {}

    func initialize(req: Request) -> EventLoopFuture<Void> {
        dateFormat = Application.Config.dateFormatter().dateFormat
        statusId.output.options = Metadata.Status.allCases.map(\.formFieldOption)
        statusId.output.value = MetadataStatus.draft.rawValue
        date.output.value = Application.Config.dateFormatter().string(from: Date())

        let contentFilters: [[ContentFilter]] = req.invokeAll("content-filters")
        filters.output.options = contentFilters.flatMap { $0 }.map(\.formFieldOption)
        filters.output.options.append(.init(key: "[disable-all-filters]", label: "Disable all filters"))
        return req.eventLoop.future()
    }

//    func processAfterFields(req: Request) -> EventLoopFuture<Void> {
//        image.uploadTemporaryFile(req: req)
//    }

    func read(from input: Model)  {
//        module.value = input.module
//        model.value = input.model
//        reference.value = input.reference
        slug.output.value = input.slug
        statusId.output.value = input.status.rawValue
        feedItem.output.value = input.feedItem
        date.output.value = Application.Config.dateFormatter().string(from: input.date)
        title.output.value = input.title
        excerpt.output.value = input.excerpt
        canonicalUrl.output.value = input.canonicalUrl
//        image.value.originalKey = input.imageKey
        css.output.value = input.css
        js.output.value = input.js
    }

    func write(to output: Model) {
//        output.module = module.value!
//        output.model = model.value!
//        output.reference = reference.value!
        output.slug = slug.input.value!
        output.status = Metadata.Status(rawValue: statusId.input.value!)!
        output.feedItem = feedItem.input.value ?? false
//        output.filters = filters.input.value
        output.date = Application.Config.dateFormatter().date(from: date.input.value!)!
        output.title = title.input.value?.emptyToNil
        output.excerpt = excerpt.input.value?.emptyToNil
        output.canonicalUrl = canonicalUrl.input.value?.emptyToNil
        output.css = css.input.value?.emptyToNil
        output.js = js.input.value?.emptyToNil
    }

//    func willSave(req: Request, model: Model) -> EventLoopFuture<Void> {
//        /// only delete original file if key contains frontend model key
//        let delete = image.value.delete
//        image.value.delete = false
//        if delete, let original = image.value.originalKey, original.contains(Model.path) {
//            image.value.delete = true
//        }
//        return image.save(to: Model.path, req: req).map { [unowned self] key in
//            if delete || key != nil {
//                model.imageKey = key
//            }
//            image.value.delete = false
//        }
//    }
}
