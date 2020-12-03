//
//  UserAdminController.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

struct UserAdminController: ViperAdminViewController {

    typealias Module = UserModule
    typealias Model = UserModel
    typealias EditForm = UserEditForm

    
    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.email,
    ]

    func find(_ req: Request) throws -> EventLoopFuture<Model> {
        guard
            let id = req.parameters.get(idParamKey),
            let uuid = UUID(uuidString: id)
        else {
            throw Abort(.badRequest)
        }
        return Model.findWithRolesBy(id: uuid, on: req.db).unwrap(or: Abort(.notFound))
    }

    func beforeRender(req: Request, form: EditForm) -> EventLoopFuture<Void> {
        UserRoleModel.query(on: req.db).sort(\.$name).all().mapEach(\.formFieldStringOption).map { form.roles.options = $0 }
    }
    
    func searchList(using qb: QueryBuilder<Model>, for searchTerm: String) {
        qb.filter(\.$email ~~ searchTerm)
    }

    func beforeList(req: Request, queryBuilder: QueryBuilder<Model>) throws -> QueryBuilder<Model> {
        queryBuilder.sort(\Model.$email)
    }

    func beforeCreate(req: Request, model: Model, form: EditForm) -> EventLoopFuture<Model> {
        model.id = UUID()
        /// create roles for the user
        let roles = form.roles.values.compactMap { UUID.init(uuidString: $0)}.map { UserUserRoleModel(userId: model.id!, roleId: $0) }
        return roles.create(on: req.db).map { model }
    }

    func beforeUpdate(req: Request, model: Model, form: EditForm) -> EventLoopFuture<Model> {
        /// delete old roles first
        let delete = UserUserRoleModel.query(on: req.db).filter(\.$user.$id == model.id!).delete()
        /// then we careate new roles based on the input
        let create = form.roles.values.compactMap { UUID.init(uuidString: $0)}.map { UserUserRoleModel(userId: model.id!, roleId: $0) }.create(on: req.db)
        /// we simply fetch the user model with the roles... not so efficient, but quite effective
        return req.eventLoop.flatten([delete, create]).flatMap { UserModel.findWithRolesBy(id: model.id!, on: req.db).map { $0! } }
    }

    func delete(req: Request) throws -> EventLoopFuture<String> {
        try find(req).flatMap { user in
            UserTokenModel
                .query(on: req.db)
                .filter(\.$user.$id == user.id!)
                .delete()
        }
        .throwingFlatMap { try find(req) }
        .flatMap { item in item.delete(on: req.db)
        .map { item.id!.uuidString } }
    }
    
    
}

