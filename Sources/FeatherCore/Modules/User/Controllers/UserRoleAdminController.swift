//
//  UserRoleAdminController.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

struct UserRoleAdminController: ViperAdminViewController {
    
    typealias Module = UserModule
    typealias Model = UserRoleModel
    typealias EditForm = UserRoleEditForm

    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.name,
    ]
    
    func find(_ req: Request) throws -> EventLoopFuture<Model> {
        guard
            let id = req.parameters.get(idParamKey),
            let uuid = UUID(uuidString: id)
        else {
            throw Abort(.badRequest)
        }
        return Model.findWithPermissionsBy(id: uuid, on: req.db).unwrap(or: Abort(.notFound))
    }

    func searchList(using qb: QueryBuilder<Model>, for searchTerm: String) {
        qb.filter(\.$name ~~ searchTerm)
    }

    func beforeList(req: Request, queryBuilder: QueryBuilder<Model>) throws -> QueryBuilder<Model> {
        queryBuilder.sort(\Model.$name)
    }
    
    func beforeRender(req: Request, form: EditForm) -> EventLoopFuture<Void> {
        UserPermissionModel.query(on: req.db).sort(\.$name).all().mapEach(\.formFieldStringOption).map { form.permissions.options = $0 }
    }

    func beforeCreate(req: Request, model: Model, form: EditForm) -> EventLoopFuture<Model> {
        model.id = UUID()
        /// create permissions for the role
        let permissions = form.permissions.values.compactMap { UUID.init(uuidString: $0)}.map { UserRolePermissionModel(roleId: model.id!, permissionId: $0) }
        return permissions.create(on: req.db).map { model }
    }

    func beforeUpdate(req: Request, model: Model, form: EditForm) -> EventLoopFuture<Model> {
        /// delete old permissions first
        let delete = UserRolePermissionModel.query(on: req.db).filter(\.$role.$id == model.id!).delete()
        /// then we careate new permissions based on the input
        let create = form.permissions.values.compactMap { UUID.init(uuidString: $0)}.map { UserRolePermissionModel(roleId: model.id!, permissionId: $0) }.create(on: req.db)
        /// we simply fetch the role model with the permissions... not so efficient, but quite effective
        return req.eventLoop.flatten([delete, create]).flatMap { UserRoleModel.findWithPermissionsBy(id: model.id!, on: req.db).map { $0! } }
    }
}

