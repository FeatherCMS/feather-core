//
//  UserEditForm.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

struct UserAccountEditForm: FeatherForm {
    
    var context: FeatherFormContext<UserAccountModel>
    
    init() {
        context = .init()
        context.form.fields = createFormFields()
    }

    private func createFormFields() -> [FormComponent] {
        [
            TextField(key: "email")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator.required($1),
                    FormFieldValidator($1, "Email must be unique", nil) { field, req in
                        Model.isUniqueBy(\.$email == field.input, req: req)
                    }
                ] }
                .read { $1.output.value = context.model?.email }
                .write { context.model?.email = $1.input },
            
            TextField(key: "password")
                .write { req, field -> Void in
                    if !field.input.isEmpty {
                        context.model?.password = try! Bcrypt.hash(field.input)
                    }
                },
            
            ToggleField(key: "root")
                .read { $1.output.value = context.model?.root ?? false }
                .write { context.model?.root = $1.input },
            
            CheckboxField(key: "roles")
                .load { req, field in
                    UserRoleModel.query(on: req.db).all()
                        .mapEach(\.formFieldOption)
                        .map { field.output.options = $0 }
                }
                .read { req, field in
                    field.output.values = context.model?.roles.compactMap { $0.identifier } ?? []
                }
                .save { req, field in
                    let values = field.input.compactMap { UUID(uuidString: $0) }
                    return context.model!.$roles.reAttach(ids: values, on: req.db)
                },
            
        ]
    }
}
