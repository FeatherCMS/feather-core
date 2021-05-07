//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 07..
//

final class UserInstallForm: Form {

    var email: String = ""
    var password: String = ""

    init() {
        super.init()

        submit = "Create user"
        action.url = "/install/user/?next=true"
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
                ] }
                .read { [unowned self] in $1.output.value = email }
                .write { [unowned self] in email = $1.input },
            
            TextField(key: "password")
                .config {
                    $0.output.required = true
                    $0.output.format = .password
                }
                .validators { [
                    FormFieldValidator.required($1),
                ] }
                .read { [unowned self] in $1.output.value = password }
                .write { [unowned self] in  password = $1.input },
        ]
    }

    override func save(req: Request) -> EventLoopFuture<Void> {
        super.save(req: req).flatMap { [unowned self] in
            UserAccountModel(email: email, password: try! Bcrypt.hash(password), root: true).create(on: req.db)
        }
    }
}
