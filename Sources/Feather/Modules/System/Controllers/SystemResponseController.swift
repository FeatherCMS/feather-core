//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//


extension SystemManifestContext: Content {}

struct SystemResponseController {
    
    func handle(_ req: Request) async throws -> Response {
        guard req.feather.config.install.isCompleted else {
            let currentStep = req.feather.config.install.currentStep
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
            if req.url.path == "/" {
                let template = SystemWebPageTemplate(.init(title: "Hello", message: "World"))
                return req.templates.renderHtml(template)
            }
            throw Abort(.notFound)
        }
        return response
    }
    
    // MARK: - web related stuff
    
    func renderSitemapTemplate(_ req: Request) async throws -> Response {
        let metadatas = try await req.system.metadata.list()
        let template = SystemSitemapTemplate(.init(items: metadatas))
        return req.templates.renderXml(template)
    }

    func renderRssTemplate(_ req: Request) async throws -> Response {
        let metadatas = try await req.system.metadata.listFeedItems()
        let template = SystemRssTemplate(.init(items: metadatas))
        return req.templates.renderXml(template)
    }

    func renderRobotsTemplate(_ req: Request) async throws -> Response {
        let robots = """
            Sitemap: \(req.feather.baseUrl)\(req.feather.config.paths.sitemap.safePath())

            User-agent: *
            Disallow: \(req.feather.config.paths.admin.safePath())
            Disallow: \(req.feather.config.paths.api.safePath())
            """
        return Response(status: .ok,
                        headers: [
                            "content-type": "text/plain"
                        ],
                        body: .init(string: robots))
    }
    
    func renderManifestFile(_ req: Request) async throws -> SystemManifestContext {
        // @TODO: use web assets hook & proper name instead of hardcoded values
        SystemManifestContext(shortName: "Feather",
                           name: "Feather CMS",
                           startUrl: "",
                           themeColor: "#fff",
                           backgroundColor: "#fff",
                           display: .standalone,
                           icons: getWebIcons() + [
                                .init(src: "/img/web/icons/mask.svg", sizes: "512x512", type: "image/svg+xml"),
                           ],
                           shortcuts: [])
    }
    
    private func getWebIcons() -> [SystemManifestContext.Icon] {
        [57, 72, 76, 114, 120, 144, 152, 180, 192].map {
            .init(src: "/img/web/apple/icons/\($0).png", sizes: "\($0)x\($0)", type: "image/png")
        }
    }
}
