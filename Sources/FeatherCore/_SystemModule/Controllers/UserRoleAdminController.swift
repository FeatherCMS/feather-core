//
//  UserRoleAdminController.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

//struct UserRoleAdminController: AdminViewController {
//        
//    typealias Module = SystemModule
//    typealias Model = SystemRoleModel
//    typealias CreateForm = SystemRoleEditForm
//    typealias UpdateForm = SystemRoleEditForm
//
//    
//    func findBy(_ id: UUID, on db: Database) -> EventLoopFuture<Model> {
//        Model.findWithPermissionsBy(id: id, on: db).unwrap(or: Abort(.notFound, reason: "User role not found"))
//    }
//
//    func afterCreate(req: Request, form: CreateForm, model: Model) -> EventLoopFuture<Model> {
//        findBy(model.id!, on: req.db)
//    }
//
//    func afterUpdate(req: Request, form: UpdateForm, model: Model) -> EventLoopFuture<Model> {
//        findBy(model.id!, on: req.db)
//    }
//    
//    func listTable(_ models: [Model]) -> Table {
//        Table(columns: ["name"], rows: models.map { model in
//            TableRow(id: model.identifier, cells: [TableCell(model.name)])
//        })
//    }
//    
//    func getContext(req: Request, model: Model) -> GetViewContext {
//        .init(title: "Role",
//              key: "system.roles",
//              list: .init(label: "Roles", url: "/admin/system/roles/"),
//              nav: [],
//              fields: [
//                .init(label: "Id", value: model.identifier),
//                .init(label: "Key", value: model.key),
//                .init(label: "Name", value: model.name),
//                .init(label: "Notes", value: model.notes ?? ""),
//                .init(label: "Permissions", value: model.permissions.map(\.name).joined(separator: "<br>")),
//              ])
//    }
//    
//    func deleteContext(req: Request, model: Model, formId: String, formToken: String) -> DeleteControllerContext {
//        .init(id: formId,
//              token: formToken,
//              context: model.name,
//              type: "role",
//              list: .init(label: "Roles", url: "/admin/system/roles")
//        )
//    }
//}
//
