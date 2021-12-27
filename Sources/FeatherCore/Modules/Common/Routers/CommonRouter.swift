//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

struct CommonRouter: FeatherRouter {
    
    let fileAdminController = CommonFileAdminController()
    let fileApiController = CommonFileApiController()
    let variableAdminController = CommonVariableAdminController()
    let variableApiController = CommonVariableApiController()

    func adminRoutesHook(args: HookArguments) {
        variableAdminController.setupRoutes(args.routes)

        let moduleRoutes = args.routes.grouped("common")
        moduleRoutes.get("files", use: fileAdminController.listView)
        
        let filesRoutes = moduleRoutes.grouped("files")
        
        filesRoutes.get("directory", use: fileAdminController.createDirectoryView)
        filesRoutes.post("directory", use: fileAdminController.createDirectoryAction)
        
        filesRoutes.get("upload", use: fileAdminController.uploadView)
        filesRoutes.post("upload", use: fileAdminController.uploadAction)
        
        filesRoutes.get("delete", use: fileAdminController.deleteView)
        filesRoutes.post("delete", use: fileAdminController.deleteAction)
        
        args.routes.get("common") { req -> Response in
            let template = AdminModulePageTemplate(.init(title: "Common", message: "module information", links: [
                .init(label: "Variables", path: "/admin/common/variables/"),
                .init(label: "Files", path: "/admin/common/files/"),
            ]))
            return req.templates.renderHtml(template)
        }
    }
    
    func apiRoutesHook(args: HookArguments) {
        variableApiController.setupRoutes(args.routes)

        let moduleRoutes = args.routes.grouped("common")
        moduleRoutes.get("files", use: fileApiController.listApi)
        moduleRoutes.post("files", use: fileApiController.uploadApi)
        moduleRoutes.delete("files", use: fileApiController.deleteApi)
        
        let filesRoutes = moduleRoutes.grouped("files")
        filesRoutes.post("directory", use: fileApiController.createDirectoryApi)
    }
}
