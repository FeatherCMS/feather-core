//
//  UserLoginForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 02. 20..
//

final class UserLoginForm: Form {

    struct Input: Decodable {
        var email: String
        var password: String
    }

    var email = FormField<String>(key: "email")
    var password = FormField<String>(key: "password")

    override func fields() -> [FormFieldInterface] {
        [email, password]
    }

    required init() {
        super.init()
    }

    required init(req: Request) throws {
        try super.init(req: req)

        let context = try req.content.decode(Input.self)
        email.value = context.email
        password.value = context.password
    }
}
