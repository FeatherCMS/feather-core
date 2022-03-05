//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

struct SystemMetadataEditor: FeatherModelEditor {
    let model: SystemMetadataModel
    let form: AbstractForm

    init(model: SystemMetadataModel, form: AbstractForm) {
        self.model = model
        self.form = form
    }
    
    @FormFieldBuilder
    func createFields(_ req: Request) -> [FormField] {
        InputField("slug")
            .validators {
                FormFieldValidator($1, "Slug must be unique") { req, field in
                    try await req.system.metadata.repository.isUnique(\.$slug == field.input, FeatherMetadata.getIdParameter(req))
                }
            }
            .read { $1.output.context.value = model.slug }
            .write { model.slug = $1.input }

        // @TODO: use proper variable
        ImageField("image", path: "System/metadata")
            .read {
                if let key = model.imageKey {
                    $1.output.context.previewUrl = $0.fs.resolve(key: key)
                }
                ($1 as! ImageField).imageKey = model.imageKey
            }
            .write { model.imageKey = ($1 as! ImageField).imageKey }
        
        InputField("title")
            .read { $1.output.context.value = model.title }
            .write { model.title = $1.input }
        
        TextareaField("excerpt")
            .read { $1.output.context.value = model.excerpt }
            .write { model.excerpt = $1.input }
        
        SelectField("status")
            .config {
                $0.output.context.label.required = true
                $0.output.context.options = FeatherMetadata.Status.allCases.map { OptionContext(key: $0.rawValue, label: $0.rawValue.capitalized) }
                $0.output.context.value = FeatherMetadata.Status.draft.rawValue
            }
            .validators {
                FormFieldValidator($1, "Invalid status") { _, field in
                    FeatherMetadata.Status(rawValue: field.input) != nil
                }
            }
            .read { $1.output.context.value = model.status.rawValue }
            .write { model.status = FeatherMetadata.Status(rawValue: $1.input)! }
        
        InputField("date")
            .validators {
                FormFieldValidator($1, "Invalid date") { _, field in
                    Feather.dateFormatter().date(from: field.input) != nil
                }
            }
            .read { $1.output.context.value = Feather.dateFormatter().string(from: model.date) }
            .write { model.date = Feather.dateFormatter().date(from: $1.input) ?? Date() }
        
        InputField("canonicalUrl")
            .config {
                $0.output.context.label.title = "Canonical URL"
            }
            .read { $1.output.context.value = model.canonicalUrl }
            .write { model.canonicalUrl = $1.input }
        
        ToggleField("isFeedItem")
            .config {
                $0.output.context.label.title = "Is feed item?"
            }
            .read { $1.output.context.value = model.feedItem }
            .write { model.feedItem = $1.input }
        
        CheckboxField("filters")
            .load { req, field in
                let contentFilters: [FeatherFilter] = req.invokeAllFlat("filters")
                field.output.context.options = contentFilters.map { OptionContext(key: $0.key, label: $0.label) }
            }
            .read { $1.output.context.values = model.filters }
            .write { model.filters = $1.input }
        
        
        TextareaField("css")
            .read { $1.output.context.value = model.css }
            .write { model.css = $1.input }
        
        TextareaField("js")
            .read { $1.output.context.value = model.js }
            .write { model.js = $1.input }
        
    }
}
