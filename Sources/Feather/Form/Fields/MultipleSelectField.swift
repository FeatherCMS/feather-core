//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

public final class MultipleSelectField: AbstractFormField<[String], MultipleSelectFieldTemplate> {

    public convenience init(_ key: String) {
        self.init(key: key, input: [], output: .init(.init(key: key)))
    }
    
    public override func process(req: Request) async throws {
        try await super.process(req: req)
        output.context.values = input
    }
    
    public override func render(req: Request) -> TemplateRepresentable {
        output.context.error = error
        return super.render(req: req)
    }
}

