//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import FeatherCore

struct BlogCategoryEditor: FeatherModelEditor {
    let model: BlogCategoryModel

    init(model: BlogCategoryModel) {
        self.model = model
    }

    @FormComponentBuilder
    var formFields: [FormComponent] {
        InputField("title")
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.title }
            .write { model.title = $1.input }
    }
}

