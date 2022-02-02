//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 15..
//

import SwiftHtml
import SwiftSvg
import SwiftSgml

public struct WebIndexTemplate: TemplateRepresentable {

    public var context: WebIndexContext
    var body: Tag

    public init(_ context: WebIndexContext, @TagBuilder _ builder: () -> Tag) {
        self.context = context
        self.body = builder()
    }
    
    private func getTitle(_ req: Request) -> String {
        let title = context.metadata?.title ?? context.title
        var components = [title]
        if let suffix = req.variable("webSiteTitle"), !suffix.isEmpty {
            components += ["-", suffix]
        }
        return components.joined(separator: " ")
    }
    
    private func getLogoUrl(_ req: Request, darkMode: Bool = false) -> String {
        if darkMode {
            if let logo = req.variable("webSiteLogoDark"), !logo.isEmpty {
                return req.fs.resolve(key: logo)
            }
            return "/img/web/logos/feather-logo-dark.png"
        }
        if let logo = req.variable("webSiteLogo"), !logo.isEmpty {
            return req.fs.resolve(key: logo)
        }
        return "/img/web/logos/feather-logo.png"
    }
    
    var noindex: Bool {
        if context.noindex {
            return true
        }
        if let status = context.metadata?.status, status != .published {
            return true
        }
        // @TODO: check site noindex property!!!!
        return false
    }
    
    func getCanonicalUrl(_ req: Request) -> String? {
        if let canonicalUrl = context.canonicalUrl, !canonicalUrl.isEmpty {
            return canonicalUrl
        }
        if let canonicalUrl = context.metadata?.canonicalUrl, !canonicalUrl.isEmpty {
            return canonicalUrl
        }
        if req.getQuery("page") != nil || req.getQuery("search") != nil {
            return req.absoluteUrl
        }
        return nil
    }
    
    func mainMenuItems(_ req: Request) -> [Tag] {
        req.menu("main")?.items.map {
            A($0.label)
                .href($0.path)
                .class("selected", req.url.path == $0.path)
        } ?? []
    }
    
    @TagBuilder
    func profileMenuItems(_ req: Request) -> [Tag] {
        if req.auth.has(FeatherAccount.self) {
            if req.checkPermission(Admin.permission(for: .detail)) {
                A("Admin")
                    .href(req.feather.config.paths.admin.safePath())
            }
            A("Sign out")
                .href(req.feather.config.paths.logout.safePath())
        }
        else {
            A("Sign in")
                .href(req.feather.config.paths.login.safePath())
        }
    }

    @TagBuilder
    public func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title(getTitle(req))

                //"width=device-width, initial-scale=1, viewport-fit=cover, maximum-scale=1, user-scalable=no"
                StandardMetaTemplate(.init(charset: context.charset,
                                   viewport: context.viewport,
                                   noindex: noindex))
                    .render(req)

                if let metadata = context.metadata {
                    TwitterMetaTemplate(.init(title: metadata.title ?? getTitle(req),
                                              excerpt: metadata.excerpt,
                                              imageUrl: ""))
                        .render(req)
                    OpenGraphMetaTemplate(.init(url: "",
                                         title: metadata.title ?? getTitle(req),
                                         excerpt: metadata.excerpt,
                                         imageUrl: ""))
                        .render(req)
                }
                
                ApplePwaMetaTemplate(.init(title: getTitle(req))).render(req)

                Link(rel: .manifest)
                    .href("/manifest.json")

                let css: [String] = req.invokeAllOrdered(.webCss)
                for file in context.css + css {
                    Link(rel: .stylesheet)
                        .href(file)
                }
                
                if let css = req.variable("webSiteCss") {
                    SwiftHtml.Style(css)
                        .css()
                }

                if let css = context.metadata?.css {
                    Style(css)
                        .css()
                }

                if let canonicalUrl = getCanonicalUrl(req) {
                    Link(rel: .canonical)
                        .href(canonicalUrl)
                }
            }
            Body {
                HeaderTemplate(.init(main: .init(id: "main",
                                                 icon: Text("&#9776;"),
                                                 items: mainMenuItems(req)),
                                     account: .init(id: "account",
                                                    icon: Img(src: "/img/web/profile.png", alt: "Profile"),
                                                    items: profileMenuItems(req))))
                    .render(req)

                MainTemplate(.init(body: body)).render(req)
                // req.menuItems("footer").map { LinkTemplate($0).render(req) }
                FooterTemplate(.init()).render(req)

                let js: [String] = req.invokeAllOrdered(.webJs)
                for file in context.js + js {
                    Script()
                        .type(.javascript)
                        .src(file)
                }

                if let js = req.variable("webSiteJs") {
                    Script(js)
                        .type(.javascript)
                }
                
                if let js = context.metadata?.js {
                    Script(js)
                        .type(.javascript)
                }
            }
        }
        .lang(context.lang)
    }
    
}
