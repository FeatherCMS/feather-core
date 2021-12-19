//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

struct CommonRouter: FeatherRouter {
    let variableController = CommonVariableAdminController()

    func adminRoutesHook(args: HookArguments) {
        variableController.setupAdminRoutes(args.routes)
        
        args.routes.get("common") { req -> Response in
            let template = AdminModulePageTemplate(req, .init(title: "Common", message: "module information", links: [
                .init(label: "Variables", path: "/admin/common/variables/")
            ]))
            return req.html.render(template)
        }
    }
}
