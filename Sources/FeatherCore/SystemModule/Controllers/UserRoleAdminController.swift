//
//  UserRoleAdminController.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//


struct UserRoleAdminController: AdminViewController {
    
    
    typealias Module = SystemModule
    typealias Model = SystemRoleModel
    typealias CreateForm = SystemRoleEditForm
    typealias UpdateForm = SystemRoleEditForm

    
    func findBy(_ id: UUID, on db: Database) -> EventLoopFuture<Model> {
        Model.findWithPermissionsBy(id: id, on: db).unwrap(or: Abort(.notFound, reason: "User role not found"))
    }

    func afterCreate(req: Request, form: CreateForm, model: Model) -> EventLoopFuture<Model> {
        findBy(model.id!, on: req.db)
    }

    func afterUpdate(req: Request, form: UpdateForm, model: Model) -> EventLoopFuture<Model> {
        findBy(model.id!, on: req.db)
    }
    
    func listTable(_ models: [Model]) -> Table {
        Table(columns: ["name"], rows: models.map { model in
            TableRow(id: model.id!.uuidString, cells: [TableCell(model.name)])
        })
    }
    
    func deleteContext(req: Request, model: Model, formId: String, formToken: String) -> DeleteControllerContext {
        .init(id: formId,
              token: formToken,
              context: model.name,
              type: "metadata",
              list: .init(title: "Metadatas", url: "/admin/system/metadatas")
        )
    }
}

