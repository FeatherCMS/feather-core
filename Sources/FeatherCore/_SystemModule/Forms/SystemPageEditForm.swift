////
////  FrontendPageEditForm.swift
////  FrontendModule
////
////  Created by Tibor Bodecs on 2020. 06. 09..
////

final class SystemPageEditForm: ModelForm<SystemPageModel> {

    override func initialize() {
        super.initialize()
        
        self.fields = [
            TextField(key: "title")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Title is required") { !$0.input.isEmpty },
                ] }
                .read { [unowned self] in $1.output.value = model?.title }
                .write { [unowned self] in model?.title = $1.input },

            TextareaField(key: "content")
                .config {
                    $0.output.required = true
                    $0.output.size = .xl
                }
                .validators { [
                    FormFieldValidator($1, "Content is required") { !$0.input.isEmpty },
                ] }
                .read { [unowned self] in $1.output.value = model?.content }
                .write { [unowned self] in model?.content = $1.input },
        ]
    }
}
