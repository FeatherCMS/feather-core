//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

import FeatherApi

struct SystemPermissionEditor: FeatherModelEditor {
    let model: SystemPermissionModel
    let form: AbstractForm

    init(model: SystemPermissionModel, form: AbstractForm) {
        self.model = model
        self.form = form
    }

    @FormFieldBuilder
    func createFields(_ req: Request) -> [FormField] {
        InputField("namespace")
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.namespace }
            .write { model.namespace = $1.input }
        
        InputField("context")
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.context }
            .write { model.context = $1.input }
        
        InputField("action")
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.action }
            .write { model.action = $1.input }
        
        InputField("name")
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.name }
            .write { model.name = $1.input }
        
        TextareaField("notes")
            .read { $1.output.context.value = model.notes }
            .write { model.notes = $1.input }
    }

    func validate(req: Request) async throws -> Bool {
        let isValid = try await form.validate(req: req)
        guard isValid else {
            return false
        }
        do {
            let permission = try req.content.decode(FeatherPermission.self)
            let isUnique = try await req.system.permission.isUnique(permission)
            guard isUnique else {
                form.error = "This permission already exists"
                return false
            }
            return true
        }
        catch {
            form.error = error.localizedDescription
            return false
        }
    }
}
