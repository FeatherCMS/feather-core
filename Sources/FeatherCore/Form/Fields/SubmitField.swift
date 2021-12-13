//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor

final class SubmitField: FormField<String, SubmitFieldTemplate> {

    public convenience init(_ key: String) {
        self.init(key: key, input: "", output: .init(.init(value: "Submit")))
    }
}

