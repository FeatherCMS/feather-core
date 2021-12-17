//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

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
    }
}

