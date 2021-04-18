//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//


class TextField: FormField<String, TextFieldView> {

    convenience init(key: String) {
        self.init(key: key, input: "", output: TextFieldView(key: key))
    }
    
    override func process(req: Request) throws {
        input = try req.content.get(String.self, at: key)
        output.value = input
        try super.process(req: req)
    }
    
    func persist<T>(_ keyPath: ReferenceWritableKeyPath<T, String>, _ block: @escaping (() -> T?)) -> Self where T : FeatherModel {
        persist(keyPath, \.output.value, block)
    }

    func persist<T>(_ keyPath: ReferenceWritableKeyPath<T, String?>, _ block: @escaping (() -> T?)) -> Self where T : FeatherModel {
        persist(keyPath, \.output.value, block)
    }
}
