//
//  SiteSettingsForm.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 19..
//

struct SystemSettingsForm: EditFormController {
    
    var context: EditFormContext<SystemUserModel>

    init() {
        context = .init()
        context.form.fields = createFormFields()
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
                .read { req, field in load(key: field.key, req: req).map { (field as! ImageField).imageKey = $0 } }
                .write { req, field in save(key: field.key, value: (field as! ImageField).imageKey, req: req) },

            TextField(key: "title")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Title is required") { !$0.input.isEmpty },
                ] }
                .read { req, field in load(key: field.key, req: req).map { field.output.value = $0 } }
                .write { req, field in save(key: field.key, value: field.output.value, req: req) },
            
            TextareaField(key: "excerpt")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Excerpt is required") { !$0.input.isEmpty },
                ] }
                .read { req, field in load(key: field.key, req: req).map { field.output.value = $0 } }
                .write { req, field in save(key: field.key, value: field.output.value, req: req) },

            ToggleField(key: "noindex")
                .read { req, field in load(key: field.key, req: req).map { field.output.value = Bool($0 ?? "false") ?? false } }
                .write { req, field in save(key: field.key, value: String(field.output.value), req: req) },
            
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
            
            TextareaField(key: "css")
                .read { req, field in load(key: field.key, req: req).map { field.output.value = $0 } }
                .write { req, field in save(key: field.key, value: field.output.value, req: req) },
            
            TextareaField(key: "js")
                .read { req, field in load(key: field.key, req: req).map { field.output.value = $0 } }
                .write { req, field in save(key: field.key, value: field.output.value, req: req) },
            
            TextareaField(key: "footerTop")
                .read { req, field in load(key: field.key, req: req).map { field.output.value = $0 } }
                .write { req, field in save(key: field.key, value: field.output.value, req: req) },
            
            TextareaField(key: "footerBottom")
                .read { req, field in load(key: field.key, req: req).map { field.output.value = $0 } }
                .write { req, field in save(key: field.key, value: field.output.value, req: req) },
        ]
    }
}
