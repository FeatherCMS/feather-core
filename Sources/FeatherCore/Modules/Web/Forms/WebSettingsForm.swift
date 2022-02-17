//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

final class WebSettingsForm: AbstractForm {

    init() {
        super.init()

        self.action.enctype = .multipart
        self.submit = "Save"
    }

    @FormFieldBuilder
    override func createFields(_ req: Request) -> [FormField] {

        ImageField("logo", path: "feather")
            .read {
                if let key = $0.variable("webSiteLogo") {
                    $1.output.context.previewUrl = $0.fs.resolve(key: key)
                }
                ($1 as! ImageField).imageKey = $0.variable("webSiteLogo")
            }
            .write {
                try await $0.setVariable("webSiteLogo", value: ($1 as! ImageField).imageKey)
            }

        ImageField("logo-dark", path: "feather")
            .config {
                $0.output.context.label.title = "Logo"
                $0.output.context.label.more = "(dark mode)"
            }
            .read {
                if let key = $0.variable("webSiteLogoDark") {
                    $1.output.context.previewUrl = $0.fs.resolve(key: key)
                }
                ($1 as! ImageField).imageKey = $0.variable("webSiteLogoDark")
            }
            .write {
                try await $0.setVariable("webSiteLogoDark", value: ($1 as! ImageField).imageKey)
            }

        SeparatorField()
        
        InputField("title")
            .read {
                $1.output.context.value = $0.variable("webSiteTitle")
            }
            .write {
                try await $0.setVariable("webSiteTitle", value: $1.input)
            }
        
        TextareaField("excerpt")
            .read {
                $1.output.context.value = $0.variable("webSiteExcerpt")
            }
            .write {
                try await $0.setVariable("webSiteExcerpt", value: $1.input)
            }
        
        ToggleField("noindex")
            .config {
                $0.output.context.label.title = "Disable site index"
                $0.output.context.label.more = "(robots won't index your site)"
            }
            .read {
                $1.output.context.value = Bool($0.variable("webSiteNoIndex") ?? "false") ?? false
            }
            .write {
                try await $0.setVariable("webSiteNoIndex", value: String($1.input))
            }

        SeparatorField()
        
        TextareaField("css")
            .config {
                $0.output.context.label.more = "(code injection)"
            }
            .read {
                $1.output.context.value = $0.variable("webSiteCss")
            }
            .write {
                try await $0.setVariable("webSiteCss", value: $1.input)
            }
        
        TextareaField("js")
            .config {
                $0.output.context.label.more = "(code injection)"
            }
            .read {
                $1.output.context.value = $0.variable("webSiteJs")
            }
            .write {
                try await $0.setVariable("webSiteJs", value: $1.input)
            }
        
        SeparatorField()
        
        CheckboxField("filters")
            .config {
                $0.output.context.label.more = "(global content filters)"
            }
            .read {
                let allFilters: [FeatherFilter] = $0.invokeAllFlat(.filters)
                $1.output.context.options = allFilters.map { OptionContext(key: $0.key, label: $0.label) }
                $1.output.context.values = $0.feather.config.filters
            }
            .write { $0.feather.config.filters = $1.input }
        
//        SelectField("locale")
//            .config {
//                $0.output.context.label.title = "Locale"
//                $0.output.context.options = OptionContext.locales
//
//            }
//            .validators {
//                FormFieldValidator($1, "Invalid locale value") { req, field in
//                    OptionContext.locales.map(\.key).contains(field.input)
//                }
//            }
//            .read {
//                $1.output.context.value = $0.feather.config.region.locale
//            }
//            .write {
////                Feather.config.locale.locale = Locale(identifier: $1.input)
//                $0.feather.config.region.locale = $1.input
//            }
//
//        SelectField("timezone")
//            .config {
//                $0.output.context.label.title = "Time zone"
//                $0.output.context.options = OptionContext.uniqueTimeZones
//
//            }
//            .validators {
//                FormFieldValidator($1, "Invalid time zone value") { _, field in
//                    OptionContext.uniqueTimeZones.map(\.key).contains(field.input)
//                }
//            }
//            .read {
//                $1.output.context.value = $0.feather.config.region.timezone
//            }
//            .write {
////                Feather.config.locale.timezone = TimeZone(identifier: $1.input)!
//                $0.feather.config.region.timezone = $1.input
//            }
//
//        SelectField("listLimit")
//            .config {
//                $0.output.context.label.title = "List limit"
//                $0.output.context.options = OptionContext.listLimits
//
//            }
//            .validators {
//                FormFieldValidator($1, "Invalid list limit value") { _, field in
//                    OptionContext.listLimits.map(\.key).contains(field.input)
//                }
//            }
//            .read {
//                $1.output.context.value = String($0.feather.config.listLimit)
//            }
//            .write {
//                $0.feather.config.listLimit = Int($1.input) ?? $0.feather.config.listLimit
//            }
    }
}
