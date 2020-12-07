//
//  FrontendPageAdminController.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

import Fluent

struct FrontendPageAdminController: ViperAdminViewController {
    
    typealias Module = FrontendModule
    typealias Model = FrontendPageModel
    typealias CreateForm = FrontendPageEditForm
    typealias UpdateForm = FrontendPageEditForm
    
    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.title,
    ]
    
    func listQuery(search: String, queryBuilder: QueryBuilder<FrontendPageModel>, req: Request) {
        queryBuilder.filter(\.$title ~~ search)
    }
}
