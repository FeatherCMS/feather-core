//
//  FileUploadForm.swift
//  FileModule
//
//  Created by Tibor Bodecs on 2020. 06. 03..
//

final class CommonFileUploadForm: Form {

    var name: String?

    init() {
        super.init()
        fields = createFormFields()
    }

    private func createFormFields() -> [FormComponent] {
        [
            TextField(key: "files").read { [unowned self] req, field in self.name = field.input }
        ]
    }
}

