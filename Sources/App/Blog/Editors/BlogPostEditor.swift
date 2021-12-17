//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Foundation
import FeatherCore

struct BlogPostEditor: FeatherModelEditor {
    let model: BlogPostModel
    let form: FeatherForm

    init(model: BlogPostModel, form: FeatherForm) {
        self.model = model
        self.form = form
    }

    @FormComponentBuilder
    var formFields: [FormComponent] {
        
        ImageField("image", path: Model.assetPath)
            .read {
                if let key = model.imageKey {
                    $1.output.context.previewUrl = $0.fs.resolve(key: key)
                }
                ($1 as! ImageField).imageKey = model.imageKey
            }
            .write { model.imageKey = ($1 as! ImageField).imageKey }
        
        InputField("title")
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.title }
            .write { model.title = $1.input }
        
        TextareaField("excerpt")
            .read { $1.output.context.value = model.excerpt }
            .write { model.excerpt = $1.input }

        TextareaField("content")
            .read { $1.output.context.value = model.content }
            .write { model.content = $1.input }
        
        CheckboxField("categories")
            .load { req, field in
                let categories = try! await BlogCategoryModel.query(on: req.db).all()
                field.output.context.options = categories.map { OptionContext(key: $0.identifier, label: $0.title) }
            }
            .read { req, field in
                field.output.context.values = model.categories.compactMap { $0.identifier }
            }
            .save { req, field in
                let values = field.input.compactMap { UUID(uuidString: $0) }
                return try! await model.$categories.reAttach(ids: values, on: req.db)
            }
    }
}

