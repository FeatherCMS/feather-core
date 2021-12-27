//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 22..
//

final class CommonFileUploadForm: FeatherForm {

    var files: [File] = []
    
    init() {
        super.init()
        self.submit = "Upload"
        self.action.enctype = .multipart
    }

    @FormComponentBuilder
    override func createFields() -> [FormComponent] {
        MultifileField("files")
        .read { [unowned self] req, field in
            self.files = field.input
        }
    }
}
