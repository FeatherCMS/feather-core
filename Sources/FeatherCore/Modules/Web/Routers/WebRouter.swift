//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

struct WebRouter: FeatherRouter {
    
    let pageController = WebPageAdminController()
    let metadataController = WebMetadataController()
    let menuController = WebMenuAdminController()
    let menuItemController = WebMenuItemAdminController()
    
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
        // TODO: only register list & update routes!
        metadataController.setupAdminRoutes(args.routes)
        pageController.setupAdminRoutes(args.routes)
        menuController.setupAdminRoutes(args.routes)
        menuItemController.setupAdminRoutes(args.routes)
        
        args.routes.get("web") { req -> Response in
            let template = AdminModulePageTemplate(req, .init(title: "Web", message: "module information", links: [
                .init(label: "Menus", url: "/admin/web/menus/"),
                .init(label: "Pages", url: "/admin/web/pages/"),
                .init(label: "Metadatas", url: "/admin/web/metadatas/"),
            ]))
            return req.html.render(template)
        }
    }

    func adminApiRoutesHook(args: HookArguments) {
        metadataController.setupAdminApiRoutes(args.routes)
        pageController.setupAdminApiRoutes(args.routes)
        menuController.setupAdminApiRoutes(args.routes)
        menuItemController.setupAdminApiRoutes(args.routes)
    }

    // MARK: - helpers

    private func catchAll(_ req: Request) async throws -> Response {
        guard Feather.config.install.isCompleted else {
            let currentStep = Feather.config.install.currentStep
            let steps: [FeatherInstallStep] = try await req.invokeAllFlat(.installStep) + [.start, .finish]
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
            let res: Response? = try await req.invokeAllFirst(.installResponse, args: hookArguments)
            guard let res = res else {
                throw Abort(.internalServerError)
            }
            return res
        }
        let res: Response? = try await req.invokeAllFirst(.response)
        guard let response = res else {
            throw Abort(.notFound)
        }
        return response
    }
}
