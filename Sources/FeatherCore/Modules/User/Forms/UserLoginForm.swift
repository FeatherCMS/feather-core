//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 26..
//

final class UserLoginForm: AbstractForm {

    init() {
        super.init()
        self.submit = "Sign in"
    }

    @FormFieldBuilder
    override func createFields(_ req: Request) -> [FormField] {
        InputField("email")
            .config {
                $0.output.context.type = .email
            }
            .validators {
                FormFieldValidator.required($1)
                FormFieldValidator.email($1)
            }

        InputField("password")
            .config {
                $0.output.context.type = .password
            }
            .validators {
                FormFieldValidator.required($1)
            }
    }
}
