//
//  UserPermissionEditForm.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

struct UserPermissionEditForm: FeatherForm {
    
    var context: FeatherFormContext<UserPermissionModel>
    
    init() {
        context = .init()
        context.form.fields = createFormFields()
    }

    private func createFormFields() -> [FormComponent] {
        [
            TextField(key: "namespace")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator.required($1),
                ] }
                .read { $1.output.value = context.model?.namespace }
                .write { context.model?.namespace = $1.input },
            
            TextField(key: "context")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator.required($1),
                ] }
                .read { $1.output.value = context.model?.context }
                .write { context.model?.context = $1.input },
            
            TextField(key: "action")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator.required($1),
                ] }
                .read { $1.output.value = context.model?.action }
                .write { context.model?.action = $1.input },
            
            TextField(key: "name")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator.required($1),
                ] }
                .read { $1.output.value = context.model?.name }
                .write { context.model?.name = $1.input },

            TextareaField(key: "notes")
                .read { $1.output.value = context.model?.notes }
                .write { context.model?.notes = $1.input },
        ]
    }

    func validate(req: Request) -> EventLoopFuture<Bool> {
        context.validate(req: req).flatMap { isValid in
            guard isValid else {
                return req.eventLoop.future(false)
            }
            struct Permission: Decodable {
                let namespace: String
                let context: String
                let action: String
            }
            let p = try! req.content.decode(Permission.self)
            return Model.uniqueBy(p.namespace, p.context, p.action, req).map { isUnique in
                guard isUnique else {
                    context.form.error = "This permission already exists"
                    return false
                }
                return true
            }
        }
    }
}

