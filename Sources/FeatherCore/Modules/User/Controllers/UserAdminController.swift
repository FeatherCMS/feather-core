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

    func findModelBy(id: Model.IDValue, req: Request) -> EventLoopFuture<Model> {
        Model.findWithRolesBy(id: id, on: req.db).unwrap(or: Abort(.notFound))
    }

    func find(_ req: Request) throws -> EventLoopFuture<Model> {
        guard
            let id = req.parameters.get(idParamKey),
            let uuid = UUID(uuidString: id)
        else {
            throw Abort(.badRequest)
        }
        return findModelBy(id: uuid, req: req)
    }

    func searchList(using qb: QueryBuilder<Model>, for searchTerm: String) {
        qb.filter(\.$email ~~ searchTerm)
    }

    func beforeList(req: Request, queryBuilder: QueryBuilder<Model>) throws -> QueryBuilder<Model> {
        queryBuilder.sort(\Model.$email)
    }

    func afterCreate(req: Request, form: UserEditForm, model: UserModel) -> EventLoopFuture<UserModel> {
        findModelBy(id: model.id!, req: req)
    }

    func afterUpdate(req: Request, form: UserEditForm, model: UserModel) -> EventLoopFuture<UserModel> {
        findModelBy(id: model.id!, req: req)
    }

    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        UserTokenModel.query(on: req.db).filter(\.$user.$id == model.id!).delete().map { model }
    }
}
