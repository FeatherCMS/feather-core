//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

open class CheckboxField: FormField<[String], CheckboxFieldView> {

    public convenience init(key: String) {
        self.init(key: key, input: [], output: .init(key: key))
        self.output.label = key.🐣(self.output.label)
    }
    
    override open func process(req: Request) -> EventLoopFuture<Void> {
        super.process(req: req).map { [unowned self] in
            output.values = input
        }
    }
}
