//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

public extension HookName {
    static let response: HookName = "response"
    
    static let routes: HookName = "routes"
    static let middlewares: HookName = "middlewares"
    
    static let apiRoutes: HookName = "api-routes"
    static let apiMiddlewares: HookName = "api-middlewares"
    
    static let publicApiRoutes: HookName = "public-api-routes"
    static let publicApiMiddlewares: HookName = "public-api-middlewares"
    
    static let webRoutes: HookName = "web-routes"
    static let webMiddlewares: HookName = "web-middlewares"

    static let install: HookName = "install"
    static let installStep: HookName = "install-step"
    static let installResponse: HookName = "install-response"
    
    static let filters: HookName = "filters"
}

struct SystemModule: FeatherModule {
    
    let router = SystemRouter()
    
    func boot(_ app: Application) throws {
        app.hooks.register(.routes, use: router.routesHook)
        
        app.hooks.registerAsync(.installResponse, use: installResponseHook)
    }

    func config(_ app: Application) throws {
        try router.config(app)
    }
        
    func installResponseHook(args: HookArguments) async throws -> Response? {
        let info = args.installInfo
        if info.currentStep == SystemInstallStep.start.key {
            return try await SystemStartInstallStepController().handleInstallStep(args.req, info: info)
        }
        if info.currentStep == SystemInstallStep.finish.key {
            return try await SystemFinishInstallStepController().handleInstallStep(args.req, info: info)
        }
        return nil
    }
}

