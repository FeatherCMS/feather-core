//
//  SiteSettingsForm.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 19..
//

final class SystemSettingsForm: Form {

    init() {
        super.init()
        fields = createFormFields()
    }

    private func load(key: String, req: Request) -> EventLoopFuture<String?> {
        SystemVariableModel.query(on: req.db).filter(\.$key == "site" + key.capitalized).first().map { $0?.value }
    }

    private func save(key: String, value: String?, req: Request) -> EventLoopFuture<Void> {
        SystemVariableModel.query(on: req.db).filter(\.$key == "site" + key.capitalized).set(\.$value, to: value).update()
    }
    
    private func createFormFields() -> [FormComponent] {
        [
            ImageField(key: "image", path: "feather")
                .read { [unowned self] req, field in load(key: field.key, req: req).map { (field as! ImageField).imageKey = $0 } }
                .write { [unowned self] req, field in save(key: field.key, value: (field as! ImageField).imageKey, req: req) },

            TextField(key: "title")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Title is required") { !$0.input.isEmpty },
                ] }
                .read { [unowned self] req, field in load(key: field.key, req: req).map { field.output.value = $0 } }
                .write { [unowned self] req, field in save(key: field.key, value: field.output.value, req: req) },
            
            TextareaField(key: "excerpt")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Excerpt is required") { !$0.input.isEmpty },
                ] }
                .read { [unowned self] req, field in load(key: field.key, req: req).map { field.output.value = $0 } }
                .write { [unowned self] req, field in save(key: field.key, value: field.output.value, req: req) },

            ToggleField(key: "noindex")
                .read { [unowned self] req, field in load(key: field.key, req: req).map { field.output.value = Bool($0 ?? "false") ?? false } }
                .write { [unowned self] req, field in save(key: field.key, value: String(field.output.value), req: req) },
            
            SelectionField(key: "locale", value: Application.Config.locale.identifier, options: FormFieldOption.locales)
                .config {
                    $0.output.required = true
                }
                ///NOTE: validate
                .write { Application.Config.locale = Locale(identifier: $1.input) },
            
            SelectionField(key: "timezone", value: Application.Config.timezone.identifier, options: FormFieldOption.gmtTimezones)
                .config {
                    $0.output.required = true
                    $0.output.label = "Timezone"
                }
                ///NOTE: validate
                .write { Application.Config.timezone = TimeZone(identifier: $1.input)! },
            
            MultiSelectionField(key: "filters")
                .load { req, field -> Void in
                    let contentFilters: [[ContentFilter]] = req.invokeAll("content-filters")
                    field.output.options = contentFilters.flatMap { $0 }.map(\.formFieldOption)
                    field.output.values = Application.Config.filters
                }
                .write { Application.Config.filters = $1.input },
            
            TextField(key: "template").config { $0.output.value = Application.Config.template }
                .write { Application.Config.template = $1.input },
            
            SelectionField(key: "defaultListLimit",
                           value: String(Application.Config.defaultListLimit),
                           options: FormFieldOption.numbers([5, 10, 15, 20, 25, 30, 50, 100]))
                .config {
                    $0.output.label = "Default list limit"
                }
                .write { req, field -> Void in
                    if let newValue = Int(field.input) {
                        Application.Config.defaultListLimit = newValue
                    }
                },
            
            
            TextareaField(key: "css")
                .read { [unowned self] req, field in load(key: field.key, req: req).map { field.output.value = $0 } }
                .write { [unowned self] req, field in save(key: field.key, value: field.output.value, req: req) },
            
            TextareaField(key: "js")
                .read { [unowned self] req, field in load(key: field.key, req: req).map { field.output.value = $0 } }
                .write { [unowned self] req, field in save(key: field.key, value: field.output.value, req: req) },
            
            TextareaField(key: "footerTop")
                .read { [unowned self] req, field in load(key: field.key, req: req).map { field.output.value = $0 } }
                .write { [unowned self] req, field in save(key: field.key, value: field.output.value, req: req) },
            
            TextareaField(key: "footerBottom")
                .read { [unowned self] req, field in load(key: field.key, req: req).map { field.output.value = $0 } }
                .write { [unowned self] req, field in save(key: field.key, value: field.output.value, req: req) },
        ]
    }
}
