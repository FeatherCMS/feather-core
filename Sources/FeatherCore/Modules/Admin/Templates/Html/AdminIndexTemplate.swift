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
                Title(getTitle())

                StandardMetaTemplate(.init(charset: context.charset,
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
                HeaderTemplate(.init(title: getTitle(),
                                     logoLink: req.feather.config.paths.admin.safePath(),
                                     action: .init(icon: .compass, title: "View site", link: "/")))
                    .render(req)

                
                BreadcrumbTemplate(.init(links: [
                    LinkContext(label: "Admin", path: req.feather.config.paths.admin.safePath(), absolute: true),
                ] + context.breadcrumbs)).render(req)
                
                MainTemplate(.init(body: body)).render(req)
                // req.menuItems("footer").map { LinkTemplate($0).render(req) }
                FooterTemplate(.init()).render(req)

                Script()
                    .type(.javascript)
                    .src("/js/admin/admin.js")
                
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


private extension AdminIndexTemplate {
    
    func getTitle() -> String {
        context.title + " - " + "Feather"
    }
}
