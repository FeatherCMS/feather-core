//
//  SiteSettingsForm.swift
//  SiteModule
//
//  Created by Tibor Bodecs on 2020. 11. 19..
//



final class FrontendSettingsForm: Form {

    var title = FormField<String>(key: "title").required().length(max: 250)
    var excerpt = FormField<String>(key: "excerpt")
    var primaryColor = FormField<String>(key: "primaryColor")
    var secondaryColor = FormField<String>(key: "secondaryColor")
    var fontFamily = FormField<String>(key: "fontFamily")
    var fontSize = FormField<String>(key: "fontSize")
    var locale = SelectionFormField<String>(key: "locale")
    var timezone = SelectionFormField<String>(key: "timezone")
    var filters = ArraySelectionFormField<String>(key: "filters")
    var css = FormField<String>(key: "css")
    var js = FormField<String>(key: "js")
    var footer = FormField<String>(key: "footer")
    var footerBottom = FormField<String>(key: "footerBottom")
    var copy = FormField<String>(key: "copy")
    var copyYearStart = FormField<String>(key: "copyYearStart")
    var image = FileFormField(key: "image")
    var notification: String?

    var fields: [FormFieldRepresentable] {
        [title, excerpt, primaryColor, secondaryColor, fontFamily, fontSize, locale, timezone, filters, css, js, footer, footerBottom, copy, copyYearStart, image]
    }

    init() {}

    // MARK: - private
    
    private func settingsKey(for key: String) -> String { "frontend.site." + key }
    
    private func load(key: String, keyPath: ReferenceWritableKeyPath<FrontendSettingsForm, FormField<String>>, db: Database) -> EventLoopFuture<Void> {
        SystemVariableModel.find(key: settingsKey(for: key), db: db)
            .map { [unowned self] in self[keyPath: keyPath].value = $0?.value }
    }

    private func save(key: String, value: String?, db: Database) -> EventLoopFuture<Void> {
        SystemVariableModel.query(on: db)
            .filter(\.$key == settingsKey(for: key))
            .set(\.$value, to: value?.emptyToNil)
            .update()
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
            SystemVariableModel.find(key: settingsKey(for: "logo"), db: req.db)
            .map { [unowned self] in image.value.originalKey = $0?.value?.emptyToNil },
        
            SystemVariableModel.find(key: settingsKey(for: "filters"), db: req.db)
                .map { [unowned self] in filters.values = $0?.value?.split(separator: ",").map { String($0) } ?? [] },

            load(key: "title", keyPath: \.title, db: req.db),
            load(key: "excerpt", keyPath: \.excerpt, db: req.db),
            load(key: "color.primary", keyPath: \.primaryColor, db: req.db),
            load(key: "color.secondary", keyPath: \.secondaryColor, db: req.db),
            load(key: "font.family", keyPath: \.fontFamily, db: req.db),
            load(key: "font.size", keyPath: \.fontSize, db: req.db),
            
            load(key: "css", keyPath: \.css, db: req.db),
            load(key: "js", keyPath: \.js, db: req.db),
            load(key: "footer", keyPath: \.footer, db: req.db),
            load(key: "footer.bottom", keyPath: \.footerBottom, db: req.db),
            load(key: "copy", keyPath: \.copy, db: req.db),
            load(key: "copy.year.start", keyPath: \.copyYearStart, db: req.db),
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
        Application.Config.set("site.locale", value: locale.value!)
        Application.Config.set("site.timezone", value: timezone.value!)

        return req.eventLoop.flatten([
            image.save(to: FrontendModule.path, req: req)
                .flatMap { [unowned self] in save(key: "logo", value: $0, db: req.db) },
            
            save(key: "filters", value: filters.values.joined(separator: ","), db: req.db),
            save(key: "title", value: title.value, db: req.db),
            save(key: "excerpt", value: excerpt.value, db: req.db),
            save(key: "color.primary", value: primaryColor.value, db: req.db),
            save(key: "color.secondary", value: secondaryColor.value, db: req.db),
            save(key: "font.family", value: fontFamily.value, db: req.db),
            save(key: "font.size", value: fontSize.value, db: req.db),
            save(key: "css", value: css.value, db: req.db),
            save(key: "js", value: js.value, db: req.db),
            save(key: "footer", value: footer.value, db: req.db),
            save(key: "footer.bottom", value: footerBottom.value, db: req.db),
            save(key: "copy", value: copy.value, db: req.db),
            save(key: "copy.year.start", value: copyYearStart.value, db: req.db),
        ])
        .map { [unowned self] in notification = "Settings saved" }
    }
}
