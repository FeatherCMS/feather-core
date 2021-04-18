//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 18..
//

extension FormField {

    func persist<T: FeatherModel>(_ modelKeyPath: ReferenceWritableKeyPath<T, Input>,
                                  _ fieldKeyPath: ReferenceWritableKeyPath<FormField<Input, Output>, Input?>,
                                  _ block: @escaping (() -> T?)) -> Self {
        onLoad { req, field in
            field[keyPath: fieldKeyPath]  = block()?[keyPath: modelKeyPath]
            return req.eventLoop.future()
        }
        .onSave { req, field in
            block()?[keyPath: modelKeyPath] = field.input
            return req.eventLoop.future()
        }
    }
    
    func persist<T: FeatherModel>(_ modelKeyPath: ReferenceWritableKeyPath<T, Input?>,
                                  _ fieldKeyPath: ReferenceWritableKeyPath<FormField<Input, Output>, Input?>,
                                  _ block: @escaping (() -> T?)) -> Self {
        onLoad { req, field in
            field[keyPath: fieldKeyPath]  = block()?[keyPath: modelKeyPath]
            return req.eventLoop.future()
        }
        .onSave { req, field in
            block()?[keyPath: modelKeyPath] = field.input
            return req.eventLoop.future()
        }
    }
}





