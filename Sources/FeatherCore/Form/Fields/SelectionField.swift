//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

open class SelectionField: FormField<String, SelectionFieldView> {

    public convenience init(key: String, value: String, options: [FormFieldOption] = []) {
        self.init(key: key, input: value, output: .init(key: key, value: value, options: options))
        self.output.label = key.🐣(self.output.label)
    }
    
    override open func process(req: Request) -> EventLoopFuture<Void> {
        super.process(req: req).map { [unowned self] in
            output.value = input
        }
    }
}
