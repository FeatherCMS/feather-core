//
//  UserEditForm.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

//final class SystemUserEditForm: EditForm {
//    typealias Model = SystemUserModel
//
//    var modelId: UUID?
//    var email = FormField<String>(key: "email").email()
//    var password = FormField<String>(key: "password").length(max: 250)
//    var root = FormField<Bool>(key: "root")
//    var roles = ArraySelectionFormField<UUID>(key: "roles")
//    var notification: String?
//
//    var fields: [FormFieldRepresentable] {
//        [email, password, root, roles]
//    }
//
//    init() {}
//
//    func initialize(req: Request) -> EventLoopFuture<Void> {
//        root.value = false
//        return SystemRoleModel.query(on: req.db).all().mapEach(\.formFieldOption).map { [unowned self] in roles.options = $0 }
//    }
//    
//    func validateAfterFields(req: Request) -> EventLoopFuture<Bool> {
//        SystemUserModel.query(on: req.db).filter(\.$email == email.value!).first().map { [unowned self] model -> Bool in
//            if (modelId == nil && model != nil) || (modelId != nil && model != nil && modelId! != model!.id) {
//                email.error = "Email is already in use"
//                return false
//            }
//            return true
//        }
//    }
//
//    func read(from input: Model) {
//        email.value = input.email
//        root.value = input.root
//        roles.values = input.roles.compactMap { $0.id }
//    }
//
//    func write(to output: Model) {
//        output.email = email.value!
//        output.root = root.value ?? false
//        if let password = password.value, !password.isEmpty {
//            output.password = try! Bcrypt.hash(password)
//        }
//    }
//
//    func didSave(req: Request, model: Model) -> EventLoopFuture<Void> {
//        var future = req.eventLoop.future()
//        if modelId != nil {
//            future = FeatherUserRoleModel.query(on: req.db).filter(\.$user.$id == modelId!).delete()
//        }
//        return future.flatMap { [unowned self] in
//            roles.values.map { FeatherUserRoleModel(userId: model.id!, roleId: $0) }.create(on: req.db)
//        }
//    }
//
//}
