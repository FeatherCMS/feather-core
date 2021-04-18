//
//  UserPermissionEditForm.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

final class SystemPermissionEditForm: ModelForm<SystemPermissionModel> {

    override func initialize() {
        super.initialize()
        
        self.fields = [
            TextField(key: "namespace")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Namespace is required") { !$0.input.isEmpty },
                ] }
                .read { [unowned self] in $1.output.value = model?.namespace }
                .write { [unowned self] in model?.namespace = $1.input },
            
            TextField(key: "context")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Context is required") { !$0.input.isEmpty },
                ] }
                .read { [unowned self] in $1.output.value = model?.context }
                .write { [unowned self] in model?.context = $1.input },
            
            TextField(key: "action")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Action is required") { !$0.input.isEmpty },
                ] }
                .read { [unowned self] in $1.output.value = model?.action }
                .write { [unowned self] in model?.action = $1.input },
            
            TextField(key: "name")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Name is required") { !$0.input.isEmpty },
                ] }
                .read { [unowned self] in $1.output.value = model?.name }
                .write { [unowned self] in model?.name = $1.input },

            TextareaField(key: "notes")
                .read { [unowned self] in $1.output.value = model?.notes }
                .write { [unowned self] in model?.notes = $1.input },
        ]
    }

    override func validate(req: Request) -> EventLoopFuture<Bool> {
        super.validate(req: req).flatMap { [unowned self] isValid in
            guard isValid else {
                return req.eventLoop.future(false)
            }
            struct Permission: Decodable {
                let namespace: String
                let context: String
                let action: String
            }
            let p = try! req.content.decode(Permission.self)
            return SystemPermissionModel.uniqueBy(p.namespace, p.context, p.action, req).map { [unowned self] isUnique in
                guard isUnique else {
                    notification = .init(type: .error, title: "This permission already exists")
                    return false
                }
                return true
            }
        }
    }
}

