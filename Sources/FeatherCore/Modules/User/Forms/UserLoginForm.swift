//
//  UserLoginForm.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 02. 20..
//

final class UserLoginForm: Form {

    init() {
        super.init()

        submit = "Sign in"
        fields = createFormFields()
    }

    private func createFormFields() -> [FormComponent] {
        [
            TextField(key: "email")
                .config {
                    $0.output.required = true
                    $0.output.format = .email
                }
                .validators { [
                    FormFieldValidator.required($1),
                ] },
            
            TextField(key: "password")
                .config {
                    $0.output.required = true
                    $0.output.format = .password
                }
                .validators { [
                    FormFieldValidator.required($1),
                ] },
        ]
    }
}
