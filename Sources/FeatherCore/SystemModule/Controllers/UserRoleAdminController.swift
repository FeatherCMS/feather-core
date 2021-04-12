//
//  UserRoleAdminController.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//




struct UserRoleAdminController: FeatherAdminViewController {
    
    typealias Module = SystemModule
    typealias Model = SystemRoleModel
    typealias CreateForm = SystemRoleEditForm
    typealias UpdateForm = SystemRoleEditForm

//    var listAllowedOrders: [FieldKey] = [
//        Model.FieldKeys.name,
//    ]
//
//    func listQuery(search: String, queryBuilder: QueryBuilder<Model>, req: Request) {
//        queryBuilder.filter(\.$name ~~ search)
//        queryBuilder.filter(\.$key ~~ search)
//    }
    
    func findBy(_ id: UUID, on db: Database) -> EventLoopFuture<Model> {
        Model.findWithPermissionsBy(id: id, on: db).unwrap(or: Abort(.notFound, reason: "User role not found"))
    }

    func afterCreate(req: Request, form: CreateForm, model: Model) -> EventLoopFuture<Model> {
        findBy(model.id!, on: req.db)
    }

    func afterUpdate(req: Request, form: UpdateForm, model: Model) -> EventLoopFuture<Model> {
        findBy(model.id!, on: req.db)
    }
}

