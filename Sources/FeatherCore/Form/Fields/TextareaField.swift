//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

class TextareaField: FormField {

    let key: String

    var input: GenericInput<String>
    var validation: InputValidator
    var output: TextareaFieldView
    
    init(key: String, required: Bool = false) {
        self.key = key
        input = .init(key: key)
        validation = InputValidator()
        if required {
            validation.validators.append(ContentValidator<String>.required(key: key))
        }
        output = .init(key: key, required: required)
    }
    
    func process(req: Request) {
        input.process(req: req)

        output.value = input.value
    }
}
