//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

class TextField: FormField {

    let key: String

    var input: GenericFormFieldInput<String>
    var validation: InputValidator
    var output: TextFieldView
    
    init(key: String, required: Bool = false) {
        self.key = key
        input = .init(key: key)
        validation = InputValidator()
        if required {
            validation.validators.append(ContentValidator<String>.required(key: key))
        }
        output = TextFieldView(key: key, required: required, error: nil, value: nil, label: nil, placeholder: nil, more: nil, format: nil)
    }
    
    func process(req: Request) {
        input.process(req: req)

        output.value = input.value
    }
}
