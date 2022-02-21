//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

extension WebManifestContext: Content {}

struct WebFrontendController {
    
    func renderWelcomeTemplate(_ req: Request) async throws -> Response {
        let template = WebWelcomePageTemplate(.init(index: .init(title: "title"),
                                                              title: "Hello, World!",
                                                              message: "Lorem ipsum dolor sit amet"))
        return req.templates.renderHtml(template)
    }
    
    func renderSitemapTemplate(_ req: Request) async throws -> Response {
        let metadatas = try await WebMetadataModel.findAll(on: req.db)
        let api = WebMetadataApiController()
        let objects = try await api.listOutput(req, metadatas)
        let template = WebSitemapTemplate(.init(items: objects))
        return req.templates.renderXml(template)
    }

    func renderRssTemplate(_ req: Request) async throws -> Response {
        let metadatas = try await WebMetadataModel.findAll(on: req.db) { $0.filter(\.$feedItem == true) }
        let api = WebMetadataApiController()
        let objects = try await api.listOutput(req, metadatas) 
        let template = WebRssTemplate(.init(items: objects))
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
    
    func webManifestView(_ req: Request) async throws -> WebManifestContext {
        // @TODO: use web assets hook & proper name instead of hardcoded values
        WebManifestContext(shortName: "Feather",
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
    
    private func getWebIcons() -> [WebManifestContext.Icon] {
        [57, 72, 76, 114, 120, 144, 152, 180, 192].map {
            .init(src: "/img/web/apple/icons/\($0).png", sizes: "\($0)x\($0)", type: "image/png")
        }
    }
}

