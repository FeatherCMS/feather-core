//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

open class ToggleField: FormField<Bool, ToggleFieldView> {

    public convenience init(key: String) {
        self.init(key: key, input: false, output: .init(key: key))
    }
    
    override open func process(req: Request) -> EventLoopFuture<Void> {
        super.process(req: req).map { [unowned self] in
            output.value = input
        }
    }
}
