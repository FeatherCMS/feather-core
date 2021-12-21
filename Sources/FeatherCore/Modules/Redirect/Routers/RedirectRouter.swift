//
//  RedirectRouter.swift
//  
//
//  Created by Steve Tibbett on 2021-12-19
//

import Vapor

struct RedirectRouter: FeatherRouter {
 
    let ruleAdminController = RedirectRuleAdminController()

    func adminRoutesHook(args: HookArguments) {
        Feather.logger.info("RedirectRouter adminRoutesHook called, doing nothing")
        ruleAdminController.setupAdminRoutes(args.routes)
        
        args.routes.get("redirect") { req -> Response in
            let template = AdminModulePageTemplate(req, .init(title: "Redirect", message: "This module lets you configure redirect rules.", links: [
                .init(label: "Rules", path: "/admin/redirect/rules/"),
            ]))
            return req.html.render(template)
        }
    }
}
