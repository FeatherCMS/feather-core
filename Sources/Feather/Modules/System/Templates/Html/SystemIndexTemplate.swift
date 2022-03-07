//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 15..
//

import Vapor
import SwiftHtml
import SwiftSvg
import SwiftSgml

final class SystemIndexTemplate: AbstractTemplate<SystemIndexContext> {

    var body: Tag

    init(_ context: SystemIndexContext, @TagBuilder _ builder: () -> Tag) {
        self.body = builder()
        super.init(context)
    }

    override func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title(getTitle(req))

                //"width=device-width, initial-scale=1, viewport-fit=cover, maximum-scale=1, user-scalable=no"
                StandardMetaTemplate(.init(charset: context.charset,
                                   viewport: context.viewport,
                                   noindex: getNoindex(req)))
                    .render(req)

                // TODO: fix absolute URLs
                if let metadata = context.metadata {
                    TwitterMetaTemplate(.init(title: metadata.title ?? getTitle(req),
                                              excerpt: metadata.excerpt,
                                              imageUrl: metadata.imageKey?.resolve(req) ?? ""))
                        .render(req)
                    OpenGraphMetaTemplate(.init(url: "",
                                         title: metadata.title ?? getTitle(req),
                                         excerpt: metadata.excerpt,
                                         imageUrl: metadata.imageKey?.resolve(req) ?? ""))
                        .render(req)
                }
                
                Link(rel: .maskIcon)
                    .sizes("any")
                    .href("/img/\(getAssets(req))/icons/mask.svg")
                    .attribute("color", "#cafe00")

                Link(rel: .shortcutIcon)
                    .href("/img/\(getAssets(req))/favicons/favicon.ico")
                    .type("image/x-icon")

                Link(rel: .shortcutIcon)
                    .href("/img/\(getAssets(req))/favicons/favicon.png")
                    .type("image/png")
                
                ApplePwaMetaTemplate(.init(title: getTitle(req), assets: getAssets(req))).render(req)

                Link(rel: .manifest)
                    .href("/manifest.json")

                let css: [String] = req.invokeAllFlat(.webCss)
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
                HeaderTemplate(.init(title: getTitle(req),
                                     main: .init(id: "main",
                                                 icon: Text("&#9776;"),
                                                 items: mainMenuItems(req)),
                                     action: req.invoke(.webAction),
                                     assets: getAssets(req)))
                    .render(req)

                MainTemplate(.init(body: body)).render(req)
                FooterTemplate(.init()).render(req)

                let js: [String] = req.invokeAllFlat(.webJs)
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

private extension SystemIndexTemplate {
    
    func getAssets(_ req: Request) -> String {
        req.invoke(.webAssets) ?? "system"
    }

    func getTitle(_ req: Request) -> String {
        let title = context.metadata?.title ?? context.title
        var components = [title]
        if let suffix = req.variable("webSiteTitle"), !suffix.isEmpty {
            components += ["-", suffix]
        }
        return components.joined(separator: " ")
    }
    
    func getNoindex(_ req: Request) -> Bool {
        if context.noindex {
            return true
        }
        if let status = context.metadata?.status, status != .published {
            return true
        }
        if let noindex = req.variable("webSiteNoIndex") {
            return Bool(noindex) ?? false
        }
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
   
}
