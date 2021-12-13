//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 23..
//

import Vapor

public extension HookName {
    static let installModels: HookName = "install-models"
    
    static let webResponse: HookName = "web-response"
    static let webRoutes: HookName = "web-routes"
    static let webMiddlewares: HookName = "web-middlewares"
    static let webInstallStep: HookName = "web-install-step"
    static let webInstallResponse: HookName = "web-install-response"
}

struct WebModule: FeatherModule {
    
    let router = WebRouter()
    
    func boot(_ app: Application) throws {
        app.migrations.add(WebMigrations.v1())

        app.hooks.register(.routes, use: router.routesHook)
        app.hooks.register(.webResponse, use: webResponseHook)
        app.hooks.register(.webMiddlewares, use: webMiddlewaresHook)
        app.hooks.register("web-menus", use: webMenusHook)
        app.hooks.register(.webInstallStep, use: installStepHook)
        app.hooks.register(.webInstallResponse, use: installResponseHook)
        
        app.hooks.register(.adminWidgets, use: adminWidgetsHook)
        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        app.hooks.register(.adminApiRoutes, use: router.adminApiRoutesHook)
        
        try router.boot(app)
    }

    // MARK: - hooks

    func webResponseHook(args: HookArguments) async -> Response? {
        guard Feather.config.install.isCompleted else {
            let currentStep = Feather.config.install.currentStep ?? FeatherInstallStep.start.key
            let steps: [[FeatherInstallStep]] = await args.req.invokeAll(.webInstallStep)
            let orderedSteps = steps.flatMap { $0 }.sorted { $0.priority > $1.priority }.map(\.key)
            
            var hookArguments = HookArguments()
            hookArguments.nextInstallStep = FeatherInstallStep.finish.key
            hookArguments.currentInstallStep = currentStep

            if let currentIndex = orderedSteps.firstIndex(of: currentStep) {
                let nextIndex = orderedSteps.index(after: currentIndex)
                if nextIndex < orderedSteps.count {
                    hookArguments.nextInstallStep = orderedSteps[nextIndex]
                }
            }
            /// flat map error?
            let res: [Response?] = await args.req.invokeAll(.webInstallResponse, args: hookArguments)
            return res.compactMap({ $0 }).first
        }

        guard args.req.url.path == "/" else {
            return nil
        }

        let template = WebWelcomeTemplate(args.req, context: .init(index: .init(title: "title"),
                                                              title: "Hello, World!",
                                                              message: "Lorem ipsum dolor sit amet"))
        return args.req.html.render(template)
    }

    func installStepHook(args: HookArguments) async -> [FeatherInstallStep] {
        [
            .start,
            .init(key: "custom", priority: 2),
            .finish,
        ]
    }
    
    private func installPath(for step: String) -> String {
        "/" + Feather.config.paths.install + "/" + step + "/"
    }
    
    func installResponseHook(args: HookArguments) async -> Response? {
        let currentStep = Feather.config.install.currentStep ?? FeatherInstallStep.start.key
        let nextStep = args.nextInstallStep
        let performStep: Bool = args.req.query[Feather.config.install.nextQueryKey] ?? false
        
        if currentStep == FeatherInstallStep.start.key {
            if performStep {
                let _: [Void] = await args.req.invokeAll(.installModels)
                Feather.config.install.currentStep = nextStep
                return args.req.redirect(to: installPath(for: nextStep))
            }
            
            let template = WebInstallStepTemplate(args.req, .init(icon: "🪶",
                                                                  title: "Install site",
                                                                  message: "First we have to setup the necessary components.",
                                                                  link: .init(label: "Start installation →", url: "/install/?next=true")))
            return args.req.html.render(template)
        }
        
        if currentStep == "custom" {
            if performStep {
                Feather.config.install.currentStep = nextStep
                return args.req.redirect(to: installPath(for: nextStep))
            }
            
            let template = WebInstallStepTemplate(args.req, .init(icon: "💪",
                                                                  title: "Custom step site",
                                                                  message: "First we have to setup the necessary components.",
                                                                  link: .init(label: "Start installation →", url: "/install/?next=true")))
            return args.req.html.render(template)
        }
        
        if currentStep == FeatherInstallStep.finish.key {
            if performStep {
                Feather.config.install.isCompleted = true
                return args.req.redirect(to: "/")
            }
            let template = WebInstallStepTemplate(args.req, .init(icon: "🪶",
                                                                  title: "Setup completed",
                                                                  message: "Your site is now ready to use.",
                                                                  link: .init(label: "Let's get started →", url: "/install/?next=true")))
            return args.req.html.render(template)
        }

        return nil
    }

    func webMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            WebMenuMiddleware(),
            WebErrorMiddleware(),
        ]
    }

    func webMenusHook(args: HookArguments) async -> [LinkContext] {
        [
            .init(label: "Home", url: "/", priority: 100)
        ]
    }
    
    func adminWidgetsHook(args: HookArguments) async -> [TemplateRepresentable] {
        [
            WebAdminWidgetTemplate(args.req),
        ]
    }
}
