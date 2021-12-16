//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Vapor
import FeatherCore

struct BlogRouter: FeatherRouter {
 
    let categoryController = BlogCategoryAdminController()

    func adminRoutesHook(args: HookArguments) {
        categoryController.setupAdminRoutes(args.routes)
        
        args.routes.get("blog") { req -> Response in
            let template = AdminModulePageTemplate(req, .init(title: "Blog", message: "module information", links: [
                .init(label: "Categories", url: "/admin/blog/categories/")
            ]))
            return req.html.render(template)
        }
    }
}
