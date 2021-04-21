//
//  UserLoginForm.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 02. 20..
//

final class UserLoginForm: Form {

    init() {
        super.init()

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
                    FormFieldValidator($1, "Email is required") { !$0.input.isEmpty },
                ] },
            
            TextField(key: "password")
                .config {
                    $0.output.required = true
                    $0.output.format = .password
                }
                .validators { [
                    FormFieldValidator($1, "Password is required") { !$0.input.isEmpty },
                ] },
        ]
    }
}
