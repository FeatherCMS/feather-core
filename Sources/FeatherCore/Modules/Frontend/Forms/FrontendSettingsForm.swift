//
//  SiteSettingsForm.swift
//  SiteModule
//
//  Created by Tibor Bodecs on 2020. 11. 19..
//

final class FrontendSettingsForm: Form {

    struct Input: Decodable {
        var title: String
        var excerpt: String
        var primaryColor: String
        var secondaryColor: String
        var fontFamily: String
        var fontSize: String
        var locale: String
        var timezone: String
        var css: String
        var js: String
        var footer: String
        var footerBottom: String
        var copy: String
        var copyYearStart: String
        var image: File?
        var imageDelete: Bool?
    }

    var title = FormField<String>(key: "title")
    var excerpt = FormField<String>(key: "excerpt")
    var primaryColor = FormField<String>(key: "primaryColor")
    var secondaryColor = FormField<String>(key: "secondaryColor")
    var fontFamily = FormField<String>(key: "fontFamily")
    var fontSize = FormField<String>(key: "fontSize")
    var locale = SelectionFormField<String>(key: "locale")
    var timezone = SelectionFormField<String>(key: "timezone")
    var css = FormField<String>(key: "css")
    var js = FormField<String>(key: "js")
    var footer = FormField<String>(key: "footer")
    var footerBottom = FormField<String>(key: "footerBottom")
    var copy = FormField<String>(key: "copy")
    var copyYearStart = FormField<String>(key: "copyYearStart")
    var image = FormField<FileUploadValue>(key: "image")
    var notification: String?

    var fields: [AbstractFormField] {
        [title, excerpt, primaryColor, secondaryColor, fontFamily, fontSize, locale, timezone, css, js, footer, footerBottom, copy, copyYearStart, image]
    }

    init() {}

    // MARK: - private
    
    private func load(key: String, keyPath: ReferenceWritableKeyPath<FrontendSettingsForm, FormField<String>>, db: Database) -> EventLoopFuture<Void> {
        SystemVariableModel.find(key: "frontend.site." + key, db: db).map { [unowned self] in self[keyPath: keyPath].value = $0?.value }
    }

    private func save(key: String, value: String?, db: Database) -> EventLoopFuture<Void> {
        SystemVariableModel.query(on: db).filter(\.$key == "frontend.site." + key).set(\.$value, to: value?.emptyToNil).update()
    }

    // MARK: - form api
    
    func initialize(req: Request) -> EventLoopFuture<Void> {
        locale.value = Application.Config.locale.identifier
        locale.options = FormFieldOption.locales

        timezone.value = Application.Config.timezone.identifier
        timezone.options = FormFieldOption.gmtTimezones

//        form.image.value = req.variables.get("site.logo") ?? ""
        return req.eventLoop.flatten([
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

    func processInput(req: Request) throws -> EventLoopFuture<Void> {
        let context = try req.content.decode(Input.self)
        title.value = context.title
        excerpt.value = context.excerpt
        primaryColor.value = context.primaryColor
        secondaryColor.value = context.secondaryColor
        fontFamily.value = context.fontFamily
        fontSize.value = context.fontSize
        locale.value = context.locale
        timezone.value = context.timezone
        css.value = context.css
        js.value = context.js
        footer.value = context.footer
        footerBottom.value = context.footerBottom
        copy.value = context.copy
        copyYearStart.value = context.copyYearStart

//        image.delete = context.imageDelete ?? false
//        if let img = context.image, let data = img.data.getData(at: 0, length: img.data.readableBytes), !data.isEmpty {
//            image.data = data
//        }
        return req.eventLoop.future()
    }
    
    func save(req: Request) -> EventLoopFuture<Void> {
        Application.Config.set("site.locale", value: locale.value!)
        Application.Config.set("site.timezone", value: timezone.value!)

        return req.eventLoop.flatten([
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
    }
}
