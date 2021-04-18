//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//


class TextField: FormField<String, TextFieldView> {

    convenience init(key: String) {
        self.init(key: key, input: "", output: TextFieldView(key: key))
    }
    
    override func process(req: Request) throws {
        try super.process(req: req)
        output.value = input
    }
}
