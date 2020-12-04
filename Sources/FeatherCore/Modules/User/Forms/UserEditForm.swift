//
//  UserEditForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

final class UserEditForm: ModelForm<UserModel> {

    struct Input: Decodable {
        var modelId: UUID?
        var email: String
        var password: String
        var root: Bool
        var roles: [UUID]
    }

    var email = FormField<String>(key: "email").email()
    var password = FormField<String>(key: "password").length(max: 250)
    var root = FormField<Bool>(key: "root")
    var roles = FormField<[UUID]>(key: "roles")

    func initialize() {
        self.root.options = FormFieldOption.trueFalse()
        self.root.value = false
    }
    
    required init() {
        super.init()
        
        initialize()
    }

    override func fields() -> [FormFieldInterface] {
        [email, password, root, roles]
    }

    required init(req: Request) throws {
        try super.init(req: req)
        initialize()

        let context = try req.content.decode(Input.self)
        modelId = context.modelId
        email.value = context.email
        password.value = context.password
        root.value = context.root
        roles.value = context.roles
    }

    override func read(from input: Model)  {
        modelId = input.id
        email.value = input.email
        root.value = input.root
        roles.value = input.roles.compactMap { $0.id }
    }

    override func write(to output: Model) {
        output.email = email.value!
        output.root = root.value!
        if let password = password.value, !password.isEmpty {
            output.password = try! Bcrypt.hash(password)
        }
    }
}
