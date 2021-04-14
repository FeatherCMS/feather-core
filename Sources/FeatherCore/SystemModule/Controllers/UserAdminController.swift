//
//  UserAdminController.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//




struct UserAdminController: AdminViewController {

    typealias Module = SystemModule
    typealias Model = SystemUserModel
    typealias CreateForm = SystemUserEditForm
    typealias UpdateForm = SystemUserEditForm

//    var listAllowedOrders: [FieldKey] = [
//        Model.FieldKeys.email,
//    ]
//
//    func listQuery(search: String, queryBuilder: QueryBuilder<Model>, req: Request) {
//        queryBuilder.filter(\.$email ~~ search)
//    }

    func findBy(_ id: UUID, on db: Database) -> EventLoopFuture<Model> {
        Model.findWithRolesBy(id: id, on: db).unwrap(or: Abort(.notFound, reason: "User not found"))
    }

    func afterCreate(req: Request, form: CreateForm, model: Model) -> EventLoopFuture<Model> {
        findBy(model.id!, on: req.db)
    }

    func afterUpdate(req: Request, form: UpdateForm, model: Model) -> EventLoopFuture<Model> {
        findBy(model.id!, on: req.db)
    }

    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        SystemUserModel.query(on: req.db).count().flatMap { count in
            if count == 1 {
                return req.eventLoop.future(error: Abort(.badRequest, reason: "You can't delete every user"))
            }
            return SystemTokenModel.query(on: req.db).filter(\.$user.$id == model.id!).delete().map { model }
        }
    }

    
    func listTable(_ models: [Model]) -> Table {
        Table(columns: ["email"], rows: models.map { model in
            TableRow(id: model.id!.uuidString, cells: [TableCell(model.email)])
        })
    }
    
    func deleteContext(req: Request, model: Model, formId: String, formToken: String) -> DeleteControllerContext {
        .init(id: formId,
              token: formToken,
              context: model.email,
              type: "user",
              list: .init(title: "Users", url: "/admin/system/users")
        )
    }

}
