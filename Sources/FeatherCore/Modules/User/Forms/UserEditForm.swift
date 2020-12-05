//
//  UserEditForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

final class UserEditForm: ModelForm {
    typealias Model = UserModel

    struct Input: Decodable {
        var modelId: UUID?
        var email: String
        var password: String
        var root: Bool
        var roles: [UUID]
    }

    var modelId: UUID?
    var email = FormField<String>(key: "email").email()
    var password = FormField<String>(key: "password").length(max: 250)
    var root = SelectionFormField<Bool>(key: "root")
    var roles = ArraySelectionFormField<UUID>(key: "roles")
    var notification: String?

    var fields: [AbstractFormField] {
        [email, password, root, roles]
    }

    init() {}

    func initialize(req: Request) -> EventLoopFuture<Void> {
        root.options = FormFieldOption.trueFalse()
        root.value = false
        return UserRoleModel.query(on: req.db).all().mapEach(\.formFieldOption).map { [unowned self] in roles.options = $0 }
    }

    func processInput(req: Request) throws -> EventLoopFuture<Void> {
        let context = try req.content.decode(Input.self)
        modelId = context.modelId
        email.value = context.email
        password.value = context.password
        root.value = context.root
        roles.values = context.roles

        return req.eventLoop.future()
    }

    func read(from input: Model) {
        modelId = input.id
        email.value = input.email
        root.value = input.root
        roles.values = input.roles.compactMap { $0.id }
    }

    func write(to output: Model) {
        output.id = modelId ?? UUID()
        output.email = email.value!
        output.root = root.value!
        if let password = password.value, !password.isEmpty {
            output.password = try! Bcrypt.hash(password)
        }
    }

    func didSave(req: Request, model: Model) -> EventLoopFuture<Void> {
        var future = req.eventLoop.future()
        if modelId != nil {
            future = UserUserRoleModel.query(on: req.db).filter(\.$user.$id == modelId!).delete()
        }
        return future.flatMap { [unowned self] in
            roles.values.map { UserUserRoleModel(userId: model.id!, roleId: $0) }.create(on: req.db)
        }
    }

}
