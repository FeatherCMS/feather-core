//
//  File.swift
//  FileModule
//
//  Created by Tibor Bodecs on 2020. 06. 03..
//

final class CommonFileDirectoryForm: Form {

    var name: String!

    init() {
        super.init()
        fields = createFormFields()
    }

    private func createFormFields() -> [FormComponent] {
        [
            TextField(key: "name")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Name is required") { !$0.input.isEmpty },
                ] }
                .read { [unowned self] req, field in self.name = field.input }
        ]
    }
}
