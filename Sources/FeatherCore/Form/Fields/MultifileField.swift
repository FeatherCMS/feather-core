//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 26..
//

class MultifileField: FormField<[File], MultifileFieldView> {

    convenience init(key: String) {
        self.init(key: key, input: [], output: .init(key: key))
    }
    
    override func process(req: Request) -> EventLoopFuture<Void> {
        super.process(req: req).map { [unowned self] in
            output.value = ""
        }
    }
}
