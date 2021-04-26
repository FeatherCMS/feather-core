//
//  FileUploadForm.swift
//  FileModule
//
//  Created by Tibor Bodecs on 2020. 06. 03..
//

final class CommonFileUploadForm: Form {

    var files: [File] = []

    init() {
        super.init()
        fields = createFormFields()
    }

    private func createFormFields() -> [FormComponent] {
        [
            MultifileField(key: "files").read { [unowned self] req, field in self.files = field.input }
        ]
    }
}

