//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 26..
//

struct CommonFileGroupEditForm: FeatherForm {
    
    var context: FeatherFormContext<CommonFileGroupModel>
    
    init() {
        context = .init()
        context.form.fields = createFormFields()
    }

    private func createFormFields() -> [FormComponent] {
        [
            TextField(key: "title")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Title is required") { !$0.input.isEmpty },
                ] }
                .read { $1.output.value = context.model?.title }
                .write { context.model?.title = $1.input },
            
            TextField(key: "path")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Path is required") { !$0.input.isEmpty },
                ] }
                .read { $1.output.value = context.model?.path }
                .write { context.model?.path = $1.input },

            TextField(key: "excerpt")
                .read { $1.output.value = context.model?.excerpt }
                .write { context.model?.excerpt = $1.input },

            TextareaField(key: "notes")
                .read { $1.output.value = context.model?.notes }
                .write { context.model?.notes = $1.input },

        ]
    }
}
