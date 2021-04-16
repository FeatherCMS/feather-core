//
//  UserEditForm.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

final class SystemUserEditForm: EditForm {
    typealias Model = SystemUserModel

    var email = TextField(key: "email", required: true)
    var password = TextField(key: "password")
    var root = ToggleField(key: "root")
    var roles = CheckboxField(key: "roles")
    var notification: String?

    var fields: [FormFieldRepresentable] {
        [email, password, root, roles]
    }

    func uniqueKeyValidator(optional: Bool = false) -> ContentValidator<String> {
        return ContentValidator<String>(key: "email", message: "Email must be unique", asyncValidation: { value, req in
            var query = SystemUserModel.query(on: req.db).filter(\.$email == value)
            if let id = req.parameters.get("id"), let uuid = UUID(uuidString: id) {
                query = query.filter(\.$id != uuid)
            }
            return query.count().map { $0 == 0  }
        })
    }

    init() {
        email.validation.validators.append(uniqueKeyValidator())
    }

    func initialize(req: Request) -> EventLoopFuture<Void> {
        root.output.value = false
        return SystemRoleModel.query(on: req.db).all().mapEach(\.formFieldOption).map { [unowned self] in roles.output.options = $0 }
    }


    func read(from input: Model) {
        email.output.value = input.email
        root.output.value = input.root
        roles.output.values = input.roles.compactMap { $0.identifier }
    }

    func write(to output: Model) {
        output.email = email.input.value!
        output.root = root.input.value ?? false
        if let password = password.input.value, !password.isEmpty {
            output.password = try! Bcrypt.hash(password)
        }
    }

    func didSave(req: Request, model: Model) -> EventLoopFuture<Void> {
        var future = req.eventLoop.future()
        if let id = req.parameters.get("id"), let uuid = UUID(uuidString: id) {
            future = FeatherUserRoleModel.query(on: req.db).filter(\.$user.$id == uuid).delete()
        }
        return future.flatMap { [unowned self] in
            #warning("fixme")
            return (roles.input.value ?? []).map { FeatherUserRoleModel(userId: model.id!, roleId: UUID(uuidString: $0)!) }.create(on: req.db)
        }
    }

}
