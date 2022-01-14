//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 15..
//

import SwiftHtml
import SwiftSvg

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
    
    private func getLogoUrl(_ req: Request) -> String {
        if let logo = req.variable("webSiteLogo"), !logo.isEmpty {
            return req.fs.resolve(key: logo)
        }
        return "/img/web/logo.png"
    }

    @TagBuilder
    public func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title(getTitle(req))

                Meta()
                    .charset(context.charset)
                
                Meta()
                    .name(.viewport)
                    .content(context.viewport)

                // NOTE: come up with a better solution for this...
                // TODO: check site noindex property!!!!
                if context.noindex {
                    Meta()
                        .name(.robots)
                        .content("noindex")
                }
                else if let status = context.metadata?.status, status != .published {
                    Meta()
                        .name(.robots)
                        .content("noindex")
                }
                
                if let metadata = context.metadata {
                    Meta()
                        .name("twitter:card")
                        .content("summary_large_image")
                    Meta()
                        .name("twitter:title")
                        .content(getTitle(req))

                    if let excerpt = metadata.excerpt, !excerpt.isEmpty {
                        Meta()
                            .name("twitter:description")
                            .content(excerpt)
                    }
                    if let key = metadata.imageKey {
                        Meta()
                            .name("twitter:image")
                            .content(req.fs.resolve(key: key))
                    }

                    Meta()
                        .name("og:url")
                        .content(req.absoluteUrl)
                    Meta()
                        .name("og:title")
                        .content(getTitle(req))

                    if let excerpt = metadata.excerpt, !excerpt.isEmpty {
                        Meta()
                            .name("og:description")
                            .content(excerpt)
                    }
                    if let key = metadata.imageKey {
                        Meta()
                            .name("og:image")
                            .content(req.fs.resolve(key: key))
                    }

//                    Link()
//                        .rel(.manifest)
//                        .href("/manifest.json")
//                    Link()
//                        .rel(.maskIcon)
//                        .sizes("any")
//                        .href("/img/logos/feather-logo-shape.svg")
//
//                    Link()
//                        .rel("shortcut icon")
//                        .href("/img/favicons/favicon.ico")
//                        .type("image/x-icon")
//                    Link()
//                        .rel("shortcut icon")
//                        .href("/img/favicons/favicon.png")
//                        .type("image/png")
//
//                    Link()
//                        .rel("apple-touch-icon")
//                        .href("/img/apple/192.png")
//
//                    for size in [57, 72, 76, 114, 120, 144, 152, 180] {
//                        Link()
//                            .rel("apple-touch-icon")
//                            .href("/img/apple/\(size).png")
//                            .sizes("\(size)x\(size)")
//                    }
                }

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
                
                // NOTE: come up with a better solution for this...
                if let canonicalUrl = context.canonicalUrl, !canonicalUrl.isEmpty {
                    Link(rel: .canonical)
                        .href(canonicalUrl)
                }
                else if let canonicalUrl = context.metadata?.canonicalUrl, !canonicalUrl.isEmpty {
                    Link(rel: .canonical)
                        .href(canonicalUrl)
                }

                if req.getQuery("page") != nil || req.getQuery("search") != nil {
                    Link(rel: .canonical)
                        .href(req.absoluteUrl)
                }
            }
            Body {
                Header {
                    Div {
                        A {
                            Img(src: getLogoUrl(req), alt: "Logo of \(getTitle(req))")
                                .title(getTitle(req))
                                .style("width: 300px")
                        }
                        .href("/")
                        Nav {
                            Input()
                                .type(.checkbox)
                                .id("primary-menu-button")
                                .name("menu-button")
                                .class("menu-button")
                            Label {
                                Svg {
                                    Line(x1: 3, y1: 12, x2: 21, y2: 12)
                                    Line(x1: 3, y1: 6, x2: 21, y2: 6)
                                    Line(x1: 3, y1: 18, x2: 21, y2: 18)
                                }
                                .width(24)
                                .height(24)
                                .viewBox(minX: 0, minY: 0, width: 24, height: 24)
                                .fill("none")
                                .stroke("currentColor")
                                .strokeWidth(2)
                                .strokeLinecap("round")
                                .strokeLinejoin("round")
                            }
                            .for("primary-menu-button")
                            Div {
                                req.menuItems("main").map {
                                    A($0.label)
                                        .href($0.path)
                                        .class("selected", req.url.path == $0.path)
                                }
                            }
                            .class("menu-items")
                        }
                        .id("primary-menu")
                    }
                    .id("navigation")
                }
                
                Main {
                    body
                }

                Footer {
                    Section {
                        Nav {
                            if let user = req.auth.get(FeatherAccount.self) {
                                P(user.email)

                                if req.checkPermission(Admin.permission(for: .detail)) {
                                    A("Admin")
                                        .href(Feather.config.paths.admin.safePath())
                                }
                                A("Sign out")
                                    .href(Feather.config.paths.logout.safePath())
                            }
                            else {
                                if req.url.path.safePath() != Feather.config.paths.login.safePath() {
                                    A("Sign in")
                                        .href(Feather.config.paths.login.safePath())
                                }
                            }
                        }
                        Nav {
                            req.menuItems("footer").map { LinkTemplate($0).render(req) }
                        }
                    }
                }

                for file in context.js {
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
