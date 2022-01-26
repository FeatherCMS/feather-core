//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 15..
//

import SwiftHtml
import SwiftSvg

public struct AdminIndexTemplate: TemplateRepresentable {

    var context: AdminIndexContext
    var body: Tag

    public init(_ context: AdminIndexContext, @TagBuilder _ builder: () -> Tag) {
        self.context = context
        self.body = builder()
    }

    @TagBuilder
    public func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title(context.title)

                MetaTemplate(.init(charset: context.charset,
                                   viewport: context.viewport,
                                   noindex: true))
                    .render(req)

                let css: [String] = req.invokeAllOrdered(.adminCss)
                for file in context.css + css {
                    Link(rel: .stylesheet)
                        .href(file)
                }
            }
            Body {
                HeaderTemplate(.init(account: .init(id: "account",
                                                    icon: Img(src: "/img/web/profile.png", alt: "Profile"),
                                                    items: [
                                                        A("Sign out")
                                                            .href(req.feather.config.paths.logout.safePath())
                                                    ]
                                                   )))
                    .render(req)

                
                BreadcrumbTemplate(.init(links: [
                    LinkContext(label: "Admin", path: req.feather.config.paths.admin.safePath(), absolute: true)
                ] + context.breadcrumbs)).render(req)
                
                MainTemplate(.init(body: body)).render(req)
                // req.menuItems("footer").map { LinkTemplate($0).render(req) }
                FooterTemplate(.init()).render(req)

                Script()
                    .type(.javascript)
                    .src("/js/admin/main.js")
                
                let js: [String] = req.invokeAllOrdered(.adminJs)
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
