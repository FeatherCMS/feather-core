//
//  UserEditForm.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

final class SystemUserEditForm: ModelForm<SystemUserModel> {

    override func initialize() {
        super.initialize()
        
        self.fields = [
            TextField(key: "email")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Email is required") { !$0.input.isEmpty },
                    FormFieldValidator($1, "Email must be unique", nil) { field, req in
                        Model.isUniqueBy(\.$email == field.input, req: req)
                    }
                ] }
                .read { [unowned self] in $1.output.value = model?.email }
                .write { [unowned self] in model?.email = $1.input },
            
            TextField(key: "password")
                .write { [unowned self] req, field -> Void in
                    if !field.input.isEmpty {
                        model?.password = try! Bcrypt.hash(field.input)
                    }
                },
            
            ToggleField(key: "root")
                .read { [unowned self] in $1.output.value = model?.root ?? false }
                .write { [unowned self] in model?.root = $1.input },
            
            CheckboxField(key: "roles")
                .load { req, field in
                    SystemRoleModel.query(on: req.db).all()
                        .mapEach(\.formFieldOption)
                        .map { field.output.options = $0 }
                }
                .read { [unowned self] req, field in
                    field.output.values = model?.roles.compactMap { $0.identifier } ?? []
                }
                .save { [unowned self] req, field in
                    let values = field.input.compactMap { UUID(uuidString: $0) }
                    #warning("generic attach / detach")
                    
                    return model!.$roles.detach(model!.$roles.value ?? [], on: req.db).flatMap {
                        SystemRoleModel.query(on: req.db).filter(\.$id ~~ values).all().flatMap { items in
                            model!.$roles.attach(items, on: req.db)
                        }
                    }
                }
            
        ]
    }
}
