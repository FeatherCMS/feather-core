//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

class SelectionField: FormField<String, SelectionFieldView> {

    convenience init(key: String, value: String, options: [FormFieldOption] = []) {
        self.init(key: key, input: value, output: .init(key: key, value: value, options: options))
    }
    
    override func process(req: Request) -> EventLoopFuture<Void> {
        super.process(req: req).map { [unowned self] in
            output.value = input
        }
    }
}
