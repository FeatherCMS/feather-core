//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 25..
//

import Vapor

public final class InputField: FormField<String, InputFieldTemplate> {

    public convenience init(_ key: String) {
        self.init(key: key, input: "", output: .init(.init(key: key)))
    }

    public override func process(req: Request) async {
        await super.process(req: req)
        output.context.value = input
    }

    public override func render(req: Request) -> TemplateRepresentable {
        output.context.error = error
        return super.render(req: req)
    }
}

