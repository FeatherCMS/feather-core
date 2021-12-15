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
    }
}
