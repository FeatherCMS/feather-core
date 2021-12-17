//
//  File.swift
//
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import Fluent
import FeatherCoreApi

struct WebMetadataEditor: FeatherModelEditor {
    let model: WebMetadataModel
    let form: FeatherForm

    init(model: WebMetadataModel, form: FeatherForm) {
        self.model = model
        self.form = form
    }

    var formFields: [FormComponent] {
        InputField("slug")
            .validators {
                FormFieldValidator.required($1)
                FormFieldValidator($1, "Slug must be unique") { field, req in
                    await Model.isUniqueBy(\.$slug == field.input, req: req)
                }
            }
            .read { $1.output.context.value = model.slug }
            .write { model.slug = $1.input }
        
        ImageField("image", path: Model.assetPath)
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
                $0.output.context.options = WebMetadata.Status.allCases.map { OptionContext(key: $0.rawValue, label: $0.rawValue.uppercasedFirst) }
                $0.output.context.value = WebMetadata.Status.draft.rawValue
            }
            .validators {
                FormFieldValidator($1, "Invalid status") { field, _ in
                    WebMetadata.Status(rawValue: field.input) != nil
                }
            }
            .read { $1.output.context.value = model.status.rawValue }
            .write { model.status = WebMetadata.Status(rawValue: $1.input)! }
        
        InputField("canonicalUrl")
            .read { $1.output.context.value = model.canonicalUrl }
            .write { model.canonicalUrl = $1.input }
        
        
        TextareaField("css")
            .read { $1.output.context.value = model.css }
            .write { model.css = $1.input }
        
        TextareaField("js")
            .read { $1.output.context.value = model.js }
            .write { model.js = $1.input }
        
    }
}
