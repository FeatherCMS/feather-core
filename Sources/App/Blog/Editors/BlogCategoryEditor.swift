//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import FeatherCore

struct BlogCategoryEditor: FeatherModelEditor {
    let model: BlogCategoryModel
    let form: FeatherForm

    init(model: BlogCategoryModel, form: FeatherForm) {
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

        InputField("color")
            .read { $1.output.context.value = model.color }
            .write { model.color = $1.input }
        
        InputField("priority")
            .config {
                $0.output.context.value = String(100)
            }
            .read { $1.output.context.value = String(model.priority) }
            .write { model.priority = Int($1.input) ?? 100 }
    }
}

