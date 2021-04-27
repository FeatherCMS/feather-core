//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 27..
//

class ContentField: FormField<String, ContentFieldView> {

    convenience init(key: String) {
        self.init(key: key, input: "", output: .init(key: key))
    }
    
    override func process(req: Request) -> EventLoopFuture<Void> {
        super.process(req: req).map { [unowned self] in
            output.value = input
        }
    }
}
