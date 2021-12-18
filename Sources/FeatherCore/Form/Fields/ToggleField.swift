//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor

final class ToggleField: FormField<Bool, ToggleFieldTemplate> {

    public convenience init(_ key: String) {
        self.init(key: key, input: false, output: .init(.init(key: key)))
    }
    
    override func process(req: Request) async throws {
        try await super.process(req: req)
        output.context.value = input
    }
    
    override func render(req: Request) -> TemplateRepresentable {
        output.context.error = error
        return super.render(req: req)
    }
}

