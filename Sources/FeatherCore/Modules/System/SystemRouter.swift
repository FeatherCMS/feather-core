//
//  SystemRouter.swift
//  Feather
//
//  Created by Tibor Bödecs on 2020. 06. 10..
//

final class SystemRouter: ViperRouter {

    let adminController = SystemVariableAdminController()
    
    func adminRoutesHook(args: HookArguments) {
        let routes = args["routes"] as! RoutesBuilder

        let modulePath = routes.grouped(SystemModule.pathComponent)
        adminController.setupRoutes(on: modulePath, as: SystemVariableModel.pathComponent)
    }
}
