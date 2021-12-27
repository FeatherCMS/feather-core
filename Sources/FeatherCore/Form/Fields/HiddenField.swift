//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

public final class HiddenField: FormField<String, HiddenFieldTemplate> {

    public convenience init(_ key: String) {
        self.init(key: key, input: "", output: .init(.init(key: key)))
    }
    
    public override func process(req: Request) async throws {
        try await super.process(req: req)
        output.context.value = input
    }
}

