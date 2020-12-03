//
//  UserPermissionAdminController.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

struct UserPermissionAdminController: ViperAdminViewController {
    
    typealias Module = UserModule
    typealias Model = UserPermissionModel
    typealias EditForm = UserPermissionEditForm

    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.name,
    ]

    func searchList(using qb: QueryBuilder<Model>, for searchTerm: String) {
        qb.filter(\.$name ~~ searchTerm)
    }

    func beforeList(req: Request, queryBuilder: QueryBuilder<Model>) throws -> QueryBuilder<Model> {
        queryBuilder.sort(\Model.$name)
    }
}

