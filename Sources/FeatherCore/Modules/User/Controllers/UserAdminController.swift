//
//  UserAdminController.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

struct UserAdminController: ViperAdminViewController {

    typealias Module = UserModule
    typealias Model = UserModel
    typealias CreateForm = UserEditForm
    typealias UpdateForm = UserEditForm

    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.email,
    ]

    func listQuery(search: String, queryBuilder: QueryBuilder<Model>, req: Request) {
        queryBuilder.filter(\.$email ~~ search)
    }

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
        UserModel.query(on: req.db).count().flatMap { count in
            if count == 1 {
                return req.eventLoop.future(error: Abort(.badRequest, reason: "You can't delete every user"))
            }
            return UserTokenModel.query(on: req.db).filter(\.$user.$id == model.id!).delete().map { model }
        }
    }

}
