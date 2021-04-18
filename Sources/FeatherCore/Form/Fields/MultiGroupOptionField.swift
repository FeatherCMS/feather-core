//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 15..
//

class MultiGroupOptionField: FormField<[String], MultiGroupOptionFieldView> {

    convenience init(key: String) {
        self.init(key: key, input: [], output: .init(key: key))
    }
    
    override func process(req: Request) throws {
        try super.process(req: req)
        output.values = input
    }
}
