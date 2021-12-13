//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor

final class CheckboxBundleField: FormField<[String], CheckboxBundleFieldTemplate> {

    public convenience init(_ key: String) {
        self.init(key: key, input: [], output: .init(.init(key: key)))
    }
    
    override func process(req: Request) async {
        await super.process(req: req)
        output.context.values = input
    }
    
    
}

