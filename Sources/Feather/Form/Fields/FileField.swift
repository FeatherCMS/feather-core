//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor

public final class FileField: AbstractFormField<File, FileFieldTemplate> {

    public convenience init(_ key: String) {
        self.init(key: key, input: .init(data: "", filename: ""), output: .init(.init(key: key)))
    }

    public override func render(req: Request) -> TemplateRepresentable {
        output.context.error = error
        return super.render(req: req)
    }
}

