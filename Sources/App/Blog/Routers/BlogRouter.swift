//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import FeatherCore

struct BlogRouter: FeatherRouter {
 
    let categoryController = BlogCategoryAdminController()

    func adminRoutesHook(args: HookArguments) {
        categoryController.setupAdminRoutes(args.routes)
    }
}
