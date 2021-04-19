//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

class MultiSelectionField: FormField<[String], MultiSelectionFieldView> {

    convenience init(key: String, values: [String] = [], options: [FormFieldOption] = []) {
        self.init(key: key, input: values, output: .init(key: key, values: values, options: options))
    }
    
    override func process(req: Request) -> EventLoopFuture<Void> {
        super.process(req: req).map { [unowned self] in
            output.values = input
        }
    }
    
}
