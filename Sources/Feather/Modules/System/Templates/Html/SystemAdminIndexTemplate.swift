//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 15..
//

import Vapor
import SwiftHtml
import SwiftSvg

public struct SystemAdminIndexTemplate: TemplateRepresentable {

    var context: SystemAdminIndexContext
    var body: Tag

    public init(_ context: SystemAdminIndexContext, @TagBuilder _ builder: () -> Tag) {
        self.context = context
        self.body = builder()
    }

    @TagBuilder
    public func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title(getTitle())

                StandardMetaTemplate(.init(charset: context.charset,
                                   viewport: context.viewport,
                                   noindex: true))
                    .render(req)

                let css: [String] = req.invokeAllFlat(.adminCss)
                for file in context.css + css {
                    Link(rel: .stylesheet)
                        .href(file)
                }
            }
            Body {
                HeaderTemplate(.init(title: getTitle(),
                                     logoLink: req.feather.config.paths.admin.safePath(),
                                     action: .init(icon: .compass, title: "View site", link: "/"),
                                     assets: getAssets(req)))
                    .render(req)

                
                BreadcrumbTemplate(.init(links: [
                    LinkContext(label: "Admin", path: req.feather.config.paths.admin.safePath(), absolute: true),
                ] + context.breadcrumbs)).render(req)
                
                MainTemplate(.init(body: body)).render(req)
                FooterTemplate(.init(displayTopSection: true)).render(req)

                Script()
                    .type(.javascript)
                    .src("/js/system/admin.js")
                
                let js: [String] = req.invokeAllFlat(.adminJs)
                for file in context.js + js {
                    Script()
                        .type(.javascript)
                        .src(file)
                }
            }
        }
        .lang(context.lang)
    }
}

private extension SystemAdminIndexTemplate {
    
    func getTitle() -> String {
        context.title + " - " + "Feather"
    }
    
    func getAssets(_ req: Request) -> String {
        req.invoke(.adminAssets) ?? "system"
    }
}
