//
//  SiteSettingsForm.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 19..
//

final class SystemSettingsForm: Form {

    var title = TextField(key: "title", required: true)
    var excerpt = TextareaField(key: "excerpt")
    var noindex = ToggleField(key: "noindex")
    var locale = SelectionField(key: "locale")
    var timezone = SelectionField(key: "timezone")
    var filters = MultiSelectionField(key: "filters")
    var css = TextareaField(key: "css")
    var js = TextareaField(key: "js")
    var footerTop = TextareaField(key: "footerTop")
    var footerBottom = TextareaField(key: "footerBottom")
//    var image = FileFormField(key: "image")
    var notification: String?

    var fields: [FormFieldRepresentable] {
        [title, excerpt, noindex, locale, timezone, filters, css, js, footerTop, footerBottom]//, image]
    }

    init() {}

    // MARK: - private helpers
    
    private func settingsKey(for key: String) -> String { "frontend.site." + key }

    #warning("fixme")
//    private func load(key: String, keyPath: ReferenceWritableKeyPath<SystemSettingsForm, FormField>, req: Request) -> EventLoopFuture<Void> {
//        req.eventLoop.future()
//        SystemVariableModel.query(on: req.db).filter(\.$key == key).map { [unowned self] v in
//            self[keyPath: keyPath].value = v?.value
//        }
//    }

    private func save(key: String, value: String?, req: Request) -> EventLoopFuture<Void> {
        req.eventLoop.future()
//        req.setVariable(settingsKey(for: key), value: value)
    }

    // MARK: - form api
    
    func initialize(req: Request) -> EventLoopFuture<Void> {
        locale.output.value = Application.Config.locale.identifier
        locale.output.options = FormFieldOption.locales

        timezone.output.value = Application.Config.timezone.identifier
        timezone.output.options = FormFieldOption.gmtTimezones
                
        let contentFilters: [[ContentFilter]] = req.invokeAll("content-filters")
        filters.output.options = contentFilters.flatMap { $0 }.map(\.formFieldOption)

        return req.eventLoop.flatten([
//            req.variable(settingsKey(for: "logo"))
//                .map { [unowned self] in image.value.originalKey = $0?.emptyToNil },
//
//            req.variable(settingsKey(for: "filters"))
//                .map { [unowned self] in filters.values = $0?.split(separator: ",").map { String($0) } ?? [] },
//
//            req.variable(settingsKey(for: "noindex"))
//                .map { [unowned self] in noindex.value = Bool($0 ?? "false") ?? false },

//            load(key: "title", keyPath: \.title, req: req),
//            load(key: "excerpt", keyPath: \.excerpt, req: req),
//
//            load(key: "css", keyPath: \.css, req: req),
//            load(key: "js", keyPath: \.js, req: req),
//            load(key: "footer.top", keyPath: \.footerTop, req: req),
//            load(key: "footer.bottom", keyPath: \.footerBottom, req: req),
        ])
    }

    func validate(req: Request) -> EventLoopFuture<Bool> {
        validateFields(req: req).map { [unowned self] value in
            notification = "Invalid form data"
            return value
        }
    }
    
//    func processAfterFields(req: Request) -> EventLoopFuture<Void> {
//        image.uploadTemporaryFile(req: req)
//    }

    func save(req: Request) -> EventLoopFuture<Void> {
//        Application.Config.locale = locale.value
//        Application.Config.timezone =
        #warning("fixme")
//        Application.Config.set("frontend.site.locale", value: locale.value!)
//        Application.Config.set("frontend.site.timezone", value: timezone.value!)
        //Application.Config.set("frontend.site.filters", value: filters.values.joined(separator: ","))
        
        return req.eventLoop.flatten([
//            image.save(to: SystemModule.path, req: req)
//                .flatMap { [unowned self] key in
//                    if let key = key {
//                        return save(key: "logo", value: key, req: req)
//                    }
//                    return req.eventLoop.future()
//                },
            
//            save(key: "filters", value: filters.values.joined(separator: ","), req: req),
            save(key: "title", value: title.input.value, req: req),
            save(key: "excerpt", value: excerpt.input.value, req: req),
//            save(key: "noindex", value: noindex.input.value , req: req),

            save(key: "css", value: css.input.value, req: req),
            save(key: "js", value: js.input.value, req: req),
            save(key: "footer.top", value: footerTop.input.value, req: req),
            save(key: "footer.bottom", value: footerBottom.input.value, req: req),
        ])
        .map { [unowned self] in notification = "Settings saved" }
    }
}
