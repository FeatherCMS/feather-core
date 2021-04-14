//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

class SelectionField: FormField {

    let key: String

    var input: GenericFormFieldInput<String>
    var validation: InputValidator
    var output: SelectionFieldView
    
    init(key: String, required: Bool = false) {
        self.key = key
        input = .init(key: key)
        validation = InputValidator()
        if required {
            validation.validators.append(ContentValidator<String>.required(key: key))
        }
        output = .init(key: key, required: required, error: nil, value: nil, options: [], label: nil, more: nil)
    }
}
