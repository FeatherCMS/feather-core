//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

struct SystemRouter: FeatherRouter {
    
    func config(_ app: Application) throws {
        let middlewares: [Middleware] = app.invokeAllFlat(.middlewares)
        let routes = app.routes
            .grouped([SystemInstallGuardMiddleware()])
            .grouped(middlewares)

        var arguments = HookArguments()
        arguments.routes = routes
        let _: [Void] = app.invokeAll(.routes, args: arguments)
    }
    
    func routesHook(args: HookArguments) {
        // MARK: - api
        
        let publicApiMiddlewares: [Middleware] = args.app.invokeAllFlat(.publicApiMiddlewares)
        let publicApiRoutes = args.routes
            .grouped(Feather.config.paths.api.pathComponent)
            .grouped([SystemApiErrorMiddleware()])
            .grouped(publicApiMiddlewares)
        
        publicApiRoutes.get("status") { _ in "ok" }
        
        var publicApiArguments = HookArguments()
        publicApiArguments.routes = publicApiRoutes
        let _: [Void] = args.app.invokeAll(.publicApiRoutes, args: publicApiArguments)

        let apiMiddlewares: [Middleware] = args.app.invokeAllFlat(.apiMiddlewares)
        let apiRoutes = publicApiRoutes
            .grouped(Feather.config.paths.admin.pathComponent)
            .grouped(apiMiddlewares)
        var apiArguments = HookArguments()
        apiArguments.routes = apiRoutes
        let _: [Void] = args.app.invokeAll(.apiRoutes, args: apiArguments)
        
        
        // MARK: - web
        
        let webMiddlewares: [Middleware] = args.app.invokeAllFlat(.webMiddlewares)
        let webRoutes = args.routes.grouped(webMiddlewares)
        var webArguments = HookArguments()
        webArguments.routes = webRoutes
        let _: [Void] = args.app.invokeAll(.webRoutes, args: webArguments)

        webRoutes.get(use: catchAll)
        webRoutes.get(.catchall, use: catchAll)
        webRoutes.post(.catchall, use: catchAll)
    }
    
    // MARK: - catch all routes handler

    private func catchAll(_ req: Request) async throws -> Response {
        guard Feather.config.install.isCompleted else {
            let currentStep = Feather.config.install.currentStep
            let steps: [SystemInstallStep] = req.invokeAllFlat(.installStep) + [.start, .finish]
            let orderedSteps = steps.sorted { $0.priority > $1.priority }.map(\.key)

            var hookArguments = HookArguments()
            hookArguments.nextInstallStep = SystemInstallStep.finish.key
            hookArguments.currentInstallStep = currentStep

            if let currentIndex = orderedSteps.firstIndex(of: currentStep) {
                let nextIndex = orderedSteps.index(after: currentIndex)
                if nextIndex < orderedSteps.count {
                    hookArguments.nextInstallStep = orderedSteps[nextIndex]
                }
            }
            let res: Response? = try await req.invokeAllFirstAsync(.installResponse, args: hookArguments)
            guard let res = res else {
                throw Abort(.internalServerError)
            }
            return res
        }

        let res: Response? = try await req.invokeAllFirstAsync(.response)
        guard let response = res else {
            throw Abort(.notFound)
        }
        return response
    }
}
