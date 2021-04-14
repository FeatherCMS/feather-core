//
//  FrontendContentEditForm.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

//final class SystemMetadataEditForm: EditForm {
//    typealias Model = SystemMetadataModel
//
//    var modelId: UUID?
//    var module = FormField<String>(key: "module").required().length(max: 250)
//    var model = FormField<String>(key: "model").required().length(max: 250)
//    var reference = FormField<UUID>(key: "reference")
//    var slug = FormField<String>(key: "slug").length(max: 250)
//    var title = FormField<String>(key: "title").length(max: 250)
//    var excerpt = FormField<String>(key: "excerpt").length(max: 250)
//    var canonicalUrl = FormField<String>(key: "canonicalUrl").length(max: 250)
//    var statusId = SelectionFormField<String>(key: "statusId")
//    var feedItem = FormField<Bool>(key: "feedItem")
//    var filters = ArraySelectionFormField<String>(key: "filters")
//    var date = FormField<String>(key: "date")
//    var css = FormField<String>(key: "css")
//    var js = FormField<String>(key: "js")
//    var image = FileFormField(key: "image")
//    var notification: String?
//
//    var dateFormat: String?
//    
//    var fields: [FormFieldRepresentable] {
//        [module, model, reference, slug, title, excerpt, canonicalUrl, statusId, feedItem, filters, date, image, css, js]
//    }
//
//    init() {}
//
//    func initialize(req: Request) -> EventLoopFuture<Void> {
//        dateFormat = Application.Config.dateFormatter().dateFormat
//        statusId.options = Metadata.Status.allCases.map(\.formFieldOption)
//        statusId.value = MetadataStatus.draft.rawValue
//        date.value = Application.Config.dateFormatter().string(from: Date())
//
//        let contentFilters: [[ContentFilter]] = req.invokeAll("content-filters")
//        filters.options = contentFilters.flatMap { $0 }.map(\.formFieldOption)
//        filters.options.append(.init(key: "[disable-all-filters]", label: "Disable all filters"))
//        return req.eventLoop.future()
//    }
//
//    func processAfterFields(req: Request) -> EventLoopFuture<Void> {
//        image.uploadTemporaryFile(req: req)
//    }
//
//    func read(from input: Model)  {
//        module.value = input.module
//        model.value = input.model
//        reference.value = input.reference
//        slug.value = input.slug
//        statusId.value = input.status.rawValue
//        feedItem.value = input.feedItem
//        date.value = Application.Config.dateFormatter().string(from: input.date)
//        title.value = input.title
//        excerpt.value = input.excerpt
//        canonicalUrl.value = input.canonicalUrl
//        image.value.originalKey = input.imageKey
//        css.value = input.css
//        js.value = input.js
//    }
//
//    func write(to output: Model) {
//        output.module = module.value!
//        output.model = model.value!
//        output.reference = reference.value!
//        output.slug = slug.value!
//        output.status = Metadata.Status(rawValue: statusId.value!)!
//        output.feedItem = feedItem.value ?? false
//        output.filters = filters.values
//        output.date = Application.Config.dateFormatter().date(from: date.value!)!
//        output.title = title.value?.emptyToNil
//        output.excerpt = excerpt.value?.emptyToNil
//        output.canonicalUrl = canonicalUrl.value?.emptyToNil
//        output.css = css.value?.emptyToNil
//        output.js = js.value?.emptyToNil
//    }
//
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
//}
