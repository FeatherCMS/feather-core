//
// FrontendContentEditForm.swift
// FrontendModule
//
// Created by Tibor Bodecs on 2020. 06. 09..
//

struct SystemMetadataEditForm: EditFormController {
    
    var context: EditFormContext<SystemMetadataModel>
    
    var formatter: DateFormatter {
        Application.Config.dateFormatter()
    }

    init() {
        context = .init()
        context.form.title = Model.name.singular
        context.form.fields = createFormFields()
    }
    
    func load(req: Request) -> EventLoopFuture<Void> {
        guard let model = context.model else {
            return context.load(req: req)
        }
        
        context.nav.append(.init(label: "Preview", url: model.slug.safePath(), isBlank: true))
        
        if req.checkPermission(for: .init(namespace: model.module, context: model.model, action: .update)) {
            let url = ["admin", model.module, model.model, model.reference.uuidString, Model.updatePathComponent.description].joined(separator: "/").safePath()
            context.nav.append(.init(label: "Reference", url: url))
        }
        else if req.checkPermission(for: .init(namespace: model.module, context: model.model, action: .update)) {
            let url = ["admin", model.module, model.model, model.reference.uuidString].joined(separator: "/").safePath()
            context.nav.append(.init(label: "Reference", url: url))
        }
        return context.load(req: req)
    }
    
    private func createFormFields() -> [FormComponent] {
        [
            TextField(key: "slug")
                .validators { [
                    FormFieldValidator($1, "Slug must be unique", nil) { field, req in
                        Model.isUniqueBy(\.$slug == field.input, req: req)
                    }
                ] }
                .read { $1.output.value = context.model?.slug }
                .write { context.model?.slug = $1.input },
            
            ImageField(key: "image", path: Model.path)
                .read { ($1 as! ImageField).imageKey = context.model?.imageKey }
                .write { context.model?.imageKey = ($1 as! ImageField).imageKey },
            
            TextField(key: "title")
                .read { $1.output.value = context.model?.title }
                .write { context.model?.title = $1.input },
            
            TextareaField(key: "excerpt")
                .read { $1.output.value = context.model?.excerpt }
                .write { context.model?.excerpt = $1.input },
            
            TextField(key: "canonicalUrl")
                .config {
                    $0.output.label = "Canonical URL"
                }
                .read { $1.output.value = context.model?.canonicalUrl }
                .write { context.model?.canonicalUrl = $1.input },
            
            SelectionField(key: "statusId", value: MetadataStatus.draft.rawValue)
                .config {
                    $0.output.required = true
                    $0.output.label = "Status"
                    $0.output.options = Metadata.Status.allCases.map(\.formFieldOption)
                }
                .validators { [
                    FormFieldValidator($1, "Invalid status") { field in
                        Metadata.Status(rawValue: field.input) != nil
                    }
                ] }
                .read { $1.output.value = context.model?.status.rawValue }
                .write { context.model?.status = Metadata.Status(rawValue: $1.input)! },
            
            ToggleField(key: "feedItem")
                .config {
                    $0.output.required = true
                    $0.output.label = "Is feed item?"
                }
                .read { $1.output.value = context.model?.feedItem ?? false }
                .write { context.model?.feedItem = $1.input },
            
            MultiSelectionField(key: "filters")
                .load { req, field -> Void in
                    let contentFilters: [[ContentFilter]] = req.invokeAll("content-filters")
                    field.output.options = contentFilters.flatMap { $0 }.map(\.formFieldOption)
                },
            
            TextField(key: "date")
                .validators { [
                    FormFieldValidator($1, "Invalid date") { field in
                        formatter.date(from: field.input) != nil
                    }
                ] }
                .read { $1.output.value = formatter.string(from: context.model?.date ?? Date()) }
                .write { context.model?.date = formatter.date(from: $1.input) ?? Date() },
            
            TextareaField(key: "css")
                .read { $1.output.value = context.model?.css }
                .write { context.model?.css = $1.input },
            
            TextareaField(key: "js")
                .read { $1.output.value = context.model?.js }
                .write { context.model?.js = $1.input },
        ]
    }
}
