//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

public final class SubmitField: AbstractFormField<String, SubmitFieldTemplate> {

    public convenience init(_ key: String) {
        self.init(key: key, input: "", output: .init(.init(value: "Submit")))
    }
}

