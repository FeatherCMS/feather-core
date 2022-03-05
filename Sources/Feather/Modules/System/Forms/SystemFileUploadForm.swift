//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 22..
//

import Vapor

final class SystemFileUploadForm: AbstractForm {

    var files: [File] = []
    
    init() {
        super.init()
        self.submit = "Upload"
        self.action.enctype = .multipart
    }

    @FormFieldBuilder
    override func createFields(_ req: Request) -> [FormField] {
        MultipleFileField("files")
        .read { [unowned self] req, field in
            self.files = field.input
        }
    }
}
