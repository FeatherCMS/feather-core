//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Vapor
import FeatherCore

struct BlogRouter: FeatherRouter {
 
    let authorController = BlogAuthorAdminController()
    let postController = BlogPostAdminController()
    let categoryController = BlogCategoryAdminController()

    func adminRoutesHook(args: HookArguments) {
        authorController.setupAdminRoutes(args.routes)
        postController.setupAdminRoutes(args.routes)
        categoryController.setupAdminRoutes(args.routes)
        
        args.routes.get("blog") { req -> Response in
            let template = AdminModulePageTemplate(req, .init(title: "Blog", message: "module information", links: [
                .init(label: "Posts", url: "/admin/blog/posts/"),
                .init(label: "Categories", url: "/admin/blog/categories/"),
                .init(label: "Authors", url: "/admin/blog/authors/"),
            ]))
            return req.html.render(template)
        }
    }
}
