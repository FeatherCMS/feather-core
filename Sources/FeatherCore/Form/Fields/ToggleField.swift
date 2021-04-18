//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

class ToggleField: FormField<Bool, ToggleFieldView> {

    convenience init(key: String) {
        self.init(key: key, input: false, output: ToggleFieldView(key: key))
    }
    
    override func process(req: Request) throws {
        try super.process(req: req)
        output.value = input
    }

}
