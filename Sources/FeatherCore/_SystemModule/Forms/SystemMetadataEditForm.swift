//
//  FrontendContentEditForm.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

final class SystemMetadataEditForm: ModelForm<SystemMetadataModel> {
    
    var formatter: DateFormatter {
        Application.Config.dateFormatter()
    }

    override func initialize() {
        super.initialize()

        self.action = Action(multipart: true)

        self.fields = [
            
            TextField(key: "slug")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Slug is required") { !$0.input.isEmpty },
                ] }
                .read { [unowned self] in $1.output.value = model?.slug }
                .write { [unowned self] in model?.slug = $1.input },

            
            ImageField(key: "image")
                .read { [unowned self] in $1.output.originalKey = model?.imageKey }
                .process { ($1 as? ImageField)?.uploadTemporaryFile(req: $0) ?? $0.eventLoop.future() }
                .write { [unowned self] req, field in
                    (field as? ImageField)?.saveImage(to: Model.path, req: req).map { key in
                        if field.input.remove || key != nil {
                            model?.imageKey = key
                        }
                    } ?? req.eventLoop.future()
                },

            
            TextField(key: "title")
                .read { [unowned self] in $1.output.value = model?.title }
                .write { [unowned self] in model?.title = $1.input },
                
            TextareaField(key: "excerpt")
                .read { [unowned self] in $1.output.value = model?.excerpt }
                .write { [unowned self] in model?.excerpt = $1.input },
            
            TextField(key: "canonicalUrl")
                .config {
                    $0.output.label = "Canonical URL"
                }
                .read { [unowned self] in $1.output.value = model?.canonicalUrl }
                .write { [unowned self] in model?.canonicalUrl = $1.input },
            
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
                .read { [unowned self] in $1.output.value = model?.status.rawValue }
                .write { [unowned self] in model?.status = Metadata.Status(rawValue: $1.input)! },

            ToggleField(key: "feedItem")
                .config {
                    $0.output.required = true
                    $0.output.label = "Is feed item?"
                }
                .read { [unowned self] in $1.output.value = model?.feedItem ?? false }
                .write { [unowned self] in model?.feedItem = $1.input },
            
            MultiSelectionField(key: "filters")
                .load { req, field -> Void in
                    let contentFilters: [[ContentFilter]] = req.invokeAll("content-filters")
                    field.output.options = contentFilters.flatMap { $0 }.map(\.formFieldOption)
                },

            TextField(key: "date")
                .validators { [unowned self] in [
                    FormFieldValidator($1, "Invalid date") { field in
                        formatter.date(from: field.input) != nil
                    }
                ] }
                .read { [unowned self] in $1.output.value = formatter.string(from: model?.date ?? Date()) }
                .write { [unowned self] in model?.date = formatter.date(from: $1.input) ?? Date() },
            
            TextareaField(key: "css")
                .read { [unowned self] in $1.output.value = model?.css }
                .write { [unowned self] in model?.css = $1.input },
            
            TextareaField(key: "js")
                .read { [unowned self] in $1.output.value = model?.js }
                .write { [unowned self] in model?.js = $1.input },
  
        ]
    }




}
