//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 26..
//

class FileField: FormField<File?, FileFieldView> {

    convenience init(key: String) {
        self.init(key: key, input: nil, output: .init(key: key))
    }
    
    override func process(req: Request) -> EventLoopFuture<Void> {
        super.process(req: req).map { [unowned self] in
            output.value = ""
        }
    }
}
