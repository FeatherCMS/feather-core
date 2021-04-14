//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

import Foundation

class TextField: FormField {

    let key: String

    var input: GenericFormFieldInput<String>
    var validation: InputValidator
    var output: TextFieldOutput
    
    init(key: String, required: Bool = false) {
        self.key = key
        input = .init(key: key)
        validation = InputValidator()
        if required {
            validation.validators.append(ContentValidator<String>.required(key: key))
        }
        output = TextFieldOutput(key: key, required: required, error: nil, value: nil, label: nil, placeholder: nil, more: nil, format: nil)
    }
    
    
}
