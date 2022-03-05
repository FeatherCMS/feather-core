//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 17..
//

import Vapor

public final class SeparatorField: AbstractFormField<String, SeparatorFieldTemplate> {

    public convenience init() {
        self.init(key: "separator", input: "", output: .init())
    }
    
    public override func process(req: Request) async throws {
        
    }
}

