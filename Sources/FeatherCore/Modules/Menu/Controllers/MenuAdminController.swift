//
//  MenuAdminController.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

struct MenuAdminController: ViperAdminViewController {

    typealias Module = MenuModule
    typealias Model = MenuModel
    typealias EditForm = MenuEditForm
    
    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.key,
        Model.FieldKeys.name,
    ]

    func searchList(using qb: QueryBuilder<Model>, for searchTerm: String) {
        qb.filter(\.$key ~~ searchTerm)
        qb.filter(\.$name ~~ searchTerm)
    }
}
