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
    
    override func process(req: Request) -> EventLoopFuture<Void> {
        super.process(req: req).map { [unowned self] in
            output.values = input
        }
    }
}
