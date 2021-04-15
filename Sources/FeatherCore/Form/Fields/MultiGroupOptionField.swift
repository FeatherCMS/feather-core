//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 15..
//

class MultiGroupOptionField: FormField {

    let key: String

    var input: GenericFormFieldInput<[String]>
    var validation: InputValidator
    var output: MultiGroupOptionFieldView

    init(key: String, required: Bool = false) {
        self.key = key
        input = .init(key: key)
        validation = InputValidator()
        if required {
            validation.validators.append(ContentValidator<[String]>.required(key: key))
        }
        output = .init(key: key, required: required)
    }
}
