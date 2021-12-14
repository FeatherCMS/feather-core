//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

struct WebRouter: FeatherRouter {
    
//    let pagesController = WebPageAdminController()
    
    func boot(_ app: Application) throws {
        let frontendController = WebFrontendController()
        app.routes.get(Feather.config.paths.sitemap.pathComponent, use: frontendController.renderSitemapTemplate)
        app.routes.get(Feather.config.paths.rss.pathComponent, use: frontendController.renderRssTemplate)
        app.routes.get(Feather.config.paths.robots.pathComponent, use: frontendController.renderRobotsTemplate)
    }

    func routesHook(args: HookArguments) {
        let middlewares: [Middleware] = args.app.invokeAllFlat(.webMiddlewares)
        let webRoutes = args.routes.grouped(middlewares)
        var arguments = HookArguments()
        arguments.routes = webRoutes
        let _: [Void] = args.app.invokeAll(.webRoutes, args: arguments)

        webRoutes.get(use: catchAll)
        webRoutes.get(.catchall, use: catchAll)
    }
    
    func adminRoutesHook(args: HookArguments) {
//        accountController.setupAdminRoutes(args.routes)
//        roleController.setupAdminRoutes(args.routes)
//        permissionController.setupAdminRoutes(args.routes)
    }

    func adminApiRoutesHook(args: HookArguments) {
//        accountController.setupAdminApiRoutes(args.routes)
//        roleController.setupAdminApiRoutes(args.routes)
//        permissionController.setupAdminApiRoutes(args.routes)
    }

    // MARK: - helpers

    private func catchAll(_ req: Request) async throws -> Response {
        guard Feather.config.install.isCompleted else {
            let currentStep = Feather.config.install.currentStep
            let steps: [FeatherInstallStep] = await req.invokeAllFlat(.webInstallStep) + [.start, .finish]
            let orderedSteps = steps.sorted { $0.priority > $1.priority }.map(\.key)
            
            var hookArguments = HookArguments()
            hookArguments.nextInstallStep = FeatherInstallStep.finish.key
            hookArguments.currentInstallStep = currentStep

            if let currentIndex = orderedSteps.firstIndex(of: currentStep) {
                let nextIndex = orderedSteps.index(after: currentIndex)
                if nextIndex < orderedSteps.count {
                    hookArguments.nextInstallStep = orderedSteps[nextIndex]
                }
            }
            let res: Response? = await req.invokeAllFirst(.webInstallResponse, args: hookArguments)
            guard let res = res else {
                throw Abort(.internalServerError)
            }
            return res
        }
        let res: Response? = await req.invokeAllFirst(.webResponse)
        guard let response = res else {
            throw Abort(.notFound)
        }
        return response
    }
}
