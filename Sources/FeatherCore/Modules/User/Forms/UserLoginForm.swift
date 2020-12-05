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
    var notification: String?

    var fields: [AbstractFormField] {
        [email, password]
    }

    init() {}

    func processInput(req: Request) throws -> EventLoopFuture<Void> {
        let context = try req.content.decode(Input.self)
        email.value = context.email
        password.value = context.password
        return req.eventLoop.future()
    }
}
