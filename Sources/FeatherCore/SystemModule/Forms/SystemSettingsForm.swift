//
//  SiteSettingsForm.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 19..
//

final class SystemSettingsForm: Form {

    var title = FormField<String>(key: "title").required().length(max: 250)
    var excerpt = FormField<String>(key: "excerpt")
    var noindex = FormField<Bool>(key: "noindex")
    var locale = SelectionFormField<String>(key: "locale")
    var timezone = SelectionFormField<String>(key: "timezone")
    var filters = ArraySelectionFormField<String>(key: "filters")
    var css = FormField<String>(key: "css")
    var js = FormField<String>(key: "js")
    var footerTop = FormField<String>(key: "footerTop")
    var footerBottom = FormField<String>(key: "footerBottom")
    var image = FileFormField(key: "image")
    var notification: String?

    var fields: [FormFieldRepresentable] {
        [title, excerpt, noindex, locale, timezone, filters, css, js, footerTop, footerBottom, image]
    }

    init() {}

    // MARK: - private helpers
    
    private func settingsKey(for key: String) -> String { "frontend.site." + key }

    #warning("fixme")
    private func load(key: String, keyPath: ReferenceWritableKeyPath<SystemSettingsForm, FormField<String>>, req: Request) -> EventLoopFuture<Void> {
        req.eventLoop.future()
//        SystemVariableModel.query(on: req.db).filter(\.$key == key).map { [unowned self] v in
//            self[keyPath: keyPath].value = v?.value
//        }
    }

    private func save(key: String, value: String?, req: Request) -> EventLoopFuture<Void> {
        req.eventLoop.future()
//        req.setVariable(settingsKey(for: key), value: value)
    }

    // MARK: - form api
    
    func initialize(req: Request) -> EventLoopFuture<Void> {
        locale.value = Application.Config.locale.identifier
        locale.options = FormFieldOption.locales

        timezone.value = Application.Config.timezone.identifier
        timezone.options = FormFieldOption.gmtTimezones
                
        let contentFilters: [[ContentFilter]] = req.invokeAll("content-filters")
        filters.options = contentFilters.flatMap { $0 }.map(\.formFieldOption)

        return req.eventLoop.flatten([
//            req.variable(settingsKey(for: "logo"))
//                .map { [unowned self] in image.value.originalKey = $0?.emptyToNil },
//
//            req.variable(settingsKey(for: "filters"))
//                .map { [unowned self] in filters.values = $0?.split(separator: ",").map { String($0) } ?? [] },
//
//            req.variable(settingsKey(for: "noindex"))
//                .map { [unowned self] in noindex.value = Bool($0 ?? "false") ?? false },

            load(key: "title", keyPath: \.title, req: req),
            load(key: "excerpt", keyPath: \.excerpt, req: req),
            
            load(key: "css", keyPath: \.css, req: req),
            load(key: "js", keyPath: \.js, req: req),
            load(key: "footer.top", keyPath: \.footerTop, req: req),
            load(key: "footer.bottom", keyPath: \.footerBottom, req: req),
        ])
    }

    func validate(req: Request) -> EventLoopFuture<Bool> {
        guard validateFields() else {
            notification = "Invalid form data"
            return req.eventLoop.future(false)
        }
        return req.eventLoop.future(true)
    }
    
    func processAfterFields(req: Request) -> EventLoopFuture<Void> {
        image.uploadTemporaryFile(req: req)
    }

    func save(req: Request) -> EventLoopFuture<Void> {
//        Application.Config.locale = locale.value
//        Application.Config.timezone =
        #warning("fixme")
//        Application.Config.set("frontend.site.locale", value: locale.value!)
//        Application.Config.set("frontend.site.timezone", value: timezone.value!)
        //Application.Config.set("frontend.site.filters", value: filters.values.joined(separator: ","))
        
        return req.eventLoop.flatten([
            image.save(to: SystemModule.path, req: req)
                .flatMap { [unowned self] key in
                    if let key = key {
                        return save(key: "logo", value: key, req: req)
                    }
                    return req.eventLoop.future()
                },
            
            save(key: "filters", value: filters.values.joined(separator: ","), req: req),
            save(key: "title", value: title.value, req: req),
            save(key: "excerpt", value: excerpt.value, req: req),
            save(key: "noindex", value: String(noindex.value ?? false), req: req),

            save(key: "css", value: css.value, req: req),
            save(key: "js", value: js.value, req: req),
            save(key: "footer.top", value: footerTop.value, req: req),
            save(key: "footer.bottom", value: footerBottom.value, req: req),
        ])
        .map { [unowned self] in notification = "Settings saved" }
    }
}
