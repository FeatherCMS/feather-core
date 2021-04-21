////
////  FrontendPageEditForm.swift
////  FrontendModule
////
////  Created by Tibor Bodecs on 2020. 06. 09..
////

struct FrontendPageEditForm: FeatherForm {
    
    var context: FeatherFormContext<FrontendPageModel>
    
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

            TextareaField(key: "content")
                .config {
                    $0.output.required = true
                    $0.output.size = .xl
                }
                .validators { [
                    FormFieldValidator($1, "Content is required") { !$0.input.isEmpty },
                ] }
                .read { $1.output.value = context.model?.content }
                .write { context.model?.content = $1.input },
        ]
    }
}
