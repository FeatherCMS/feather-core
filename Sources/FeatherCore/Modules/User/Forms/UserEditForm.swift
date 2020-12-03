//
//  UserEditForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

final class UserEditForm: ModelForm {

    typealias Model = UserModel

    struct Input: Decodable {
        var modelId: String
        var email: String
        var password: String
        var root: String
        var roles: [String]
    }

    var modelId: String? = nil
    var email = StringFormField()
    var password = StringFormField()
    var root = StringSelectionFormField()
    var roles = StringArraySelectionFormField()
    var notification: String?

    var leafData: LeafData {
        .dictionary([
            "modelId": modelId,
            "email": email,
            "password": password,
            "root": root,
            "roles": roles,
            "notification": notification,
        ])
    }

    func initialize() {
        self.root.options = FormFieldStringOption.trueFalse()
        self.root.value = String(false)
    }
    
    init() {
        initialize()
    }

    init(req: Request) throws {
        initialize()

        let context = try req.content.decode(Input.self)
        modelId = context.modelId.emptyToNil
        email.value = context.email
        password.value = context.password
        root.value = context.root
        roles.values = context.roles
    }
    
    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
       
        if Validator.email.validate(email.value).isFailure {
            email.error = "Invalid email"
            valid = false
        }
        if Validator.count(...250).validate(email.value).isFailure {
            email.error = "Email is too long (max 250 characters)"
            valid = false
        }
        if modelId == nil && Validator.count(8...).validate(password.value).isFailure {
            password.error = "Password is too short (min 8 characters)"
            valid = false
        }
        if Validator.count(...250).validate(password.value).isFailure {
            password.error = "Password is too long (max 250 characters)"
            valid = false
        }
        if Bool(root.value) == nil {
            root.error = "Root should be a true or false value"
            valid = false
        }
        /// NOTE: validate role ids && validate root counts !!!
        return req.eventLoop.future(valid)
    }

    func read(from input: Model)  {
        modelId = input.id?.uuidString
        email.value = input.email
        root.value = String(input.root)
        roles.values = input.roles.map { $0.id!.uuidString }
    }

    func write(to output: Model) {
        output.email = email.value
        output.root = Bool(root.value)!
        if !password.value.isEmpty {
            output.password = try! Bcrypt.hash(password.value)
        }
    }
}
