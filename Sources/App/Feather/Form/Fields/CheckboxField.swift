//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor

final class CheckboxField: FormField<[String], CheckboxFieldTemplate> {

    public convenience init(_ key: String) {
        self.init(key: key, input: [], output: .init(.init(key: key)))
    }

    override func process(req: Request) async {
        await super.process(req: req)
        output.context.values = input
    }

    override func render(req: Request) -> TemplateRepresentable {
        output.context.error = error
        return super.render(req: req)
    }
}

