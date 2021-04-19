//
//  MenuEditForm.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

final class SystemMenuItemEditForm: ModelForm<SystemMenuItemModel> {

    override func initialize() {
        super.initialize()

        self.fields = [
            TextareaField(key: "icon")
                .read { [unowned self] in $1.output.value = model?.icon }
                .write { [unowned self] in model?.icon = $1.input },

            TextField(key: "label")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Label is required") { !$0.input.isEmpty },
                ] }
                .read { [unowned self] in $1.output.value = model?.label }
                .write { [unowned self] in model?.label = $1.input },
                
            TextField(key: "url")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "URL is required") { !$0.input.isEmpty },
                ] }
                .read { [unowned self] in $1.output.value = model?.url }
                .write { [unowned self] in model?.url = $1.input },

            TextField(key: "priority")
                .config { $0.output.value = String(100) }
                .read { [unowned self] in model?.priority = Int($1.input) ?? 100 }
                .write { [unowned self] in $1.output.value = String(model?.priority ?? 100) },
                
            ToggleField(key: "isBlank")
                .read { [unowned self] in $1.output.value = model?.isBlank ?? false }
                .write { [unowned self] in model?.isBlank = $1.input },
            
            TextareaField(key: "permission")
                .read { [unowned self] in $1.output.value = model?.permission }
                .write { [unowned self] in model?.permission = $1.input },
            
            HiddenField(key: "menuId")
                .read { [unowned self] req, field -> Void in
                    if let uuid = UUID(uuidString: field.input) {
                        model?.$menu.id = uuid
                    }
                }
                .write { [unowned self] req, field in
                    field.output.value = model?.$menu.id.uuidString
                },
        ]
    }
}
