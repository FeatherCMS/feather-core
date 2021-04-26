//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//


struct CommonRouter: RouteCollection {

    
    let fileController = CommonFileController()
    let variableController = CommonVariableController()
    
    let fileGroupController = CommonFileGroupController()
    
    func boot(routes: RoutesBuilder) throws {
    
    }
    
    func adminRoutesHook(args: HookArguments) {
        let adminRoutes = args.routes

        adminRoutes.get("common", use: SystemAdminMenuController(key: "common").moduleView)
        
        
        adminRoutes.register(fileGroupController)
        
        let modulePath = adminRoutes.grouped(CommonModule.moduleKeyPathComponent)
        modulePath
            .grouped(AccessGuardMiddleware(.init(namespace: "common", context: "files", action: .list)))
            .get("files", use: fileController.browserView)
        
        
        
        

        let directoryPath = modulePath.grouped("files").grouped("directory")
            .grouped(AccessGuardMiddleware(.init(namespace: "common", context: "files", action: .create)))
        directoryPath.get(use: fileController.directoryView)
//        directoryPath.post(use: fileController.directory)

        let uploadPath = modulePath.grouped("files").grouped("upload")
            .grouped(AccessGuardMiddleware(.init(namespace: "common", context: "files", action: .create)))
        uploadPath.get(use: fileController.uploadView)
//        uploadPath.post(use: fileController.upload)

        let deletePath = modulePath.grouped("files").grouped("delete")
            .grouped(AccessGuardMiddleware(.init(namespace: "common", context: "files", action: .delete)))
//        deletePath.get(use: fileController.deleteView)
//        deletePath.post(use: fileController.delete)
        
        
        adminRoutes.register(variableController)
        
    }
    
    func apiRoutesHook(args: HookArguments) {
//        let publicApiRoutes = args.routes
    }

    func apiAdminRoutesHook(args: HookArguments) {
        let apiRoutes = args.routes

        apiRoutes.registerApi(variableController)
    }
}
