//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 26..
//

final class UserLoginForm: FeatherForm {

    init() {
        super.init()
        self.submit = "Sign in"
    }

    @FormComponentBuilder
    override func createFields() -> [FormComponent] {
        InputField("email")
            .config {
                $0.output.context.type = .email
                $0.output.context.value = "root@feathercms.com"
            }
            .validators {
                FormFieldValidator.required($1)
                FormFieldValidator.email($1)
            }

        InputField("password")
            .config {
                $0.output.context.type = .password
                $0.output.context.value = "FeatherCMS"
            }
            .validators {
                FormFieldValidator.required($1)
            }
    }
}
