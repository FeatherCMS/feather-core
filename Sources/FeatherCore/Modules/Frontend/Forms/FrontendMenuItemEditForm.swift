//
//  MenuEditForm.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

struct FrontendMenuItemEditForm: FeatherForm {
    
    var context: FeatherFormContext<FrontendMenuItemModel>
    
    init() {
        context = .init()
        context.form.fields = createFormFields()
    }

    private func createFormFields() -> [FormComponent] {
        [
            TextareaField(key: "icon")
                .read { $1.output.value = context.model?.icon }
                .write { context.model?.icon = $1.input },

            TextField(key: "label")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator.required($1),
                ] }
                .read { $1.output.value = context.model?.label }
                .write { context.model?.label = $1.input },
                
            TextField(key: "url")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator.required($1),
                ] }
                .read { $1.output.value = context.model?.url }
                .write { context.model?.url = $1.input },

            TextField(key: "priority")
                .config { $0.output.value = String(100) }
                .read { $1.output.value = String(context.model?.priority ?? 100) }
                .write { context.model?.priority = Int($1.input) ?? 100 },
                
            ToggleField(key: "isBlank")
                .read { $1.output.value = context.model?.isBlank ?? false }
                .write { context.model?.isBlank = $1.input },
            
            TextField(key: "permission")
                .read { $1.output.value = context.model?.permission }
                .write { context.model?.permission = $1.input },
            
            TextareaField(key: "notes")
                .read { $1.output.value = context.model?.notes }
                .write { context.model?.notes = $1.input },
        ]
    }
    
    func load(req: Request) -> EventLoopFuture<Void> {
        guard let menuId = FrontendMenuModel.getIdParameter(req: req) else {
            return req.eventLoop.future(error: Abort(.badRequest))
        }
        let itemId = FrontendMenuItemModel.getIdParameter(req: req)
        context.breadcrumb = [
            FrontendModule.adminLink,
            FrontendMenuModel.adminLink,
            FrontendMenuModel.adminLink(for: menuId),
            FrontendMenuItemModel.adminLink(menuId: menuId),
            .init(label: itemId != nil ? "Edit" : "Create", url: req.url.path.safePath()),
        ]
        return context.load(req: req)
    }
}
