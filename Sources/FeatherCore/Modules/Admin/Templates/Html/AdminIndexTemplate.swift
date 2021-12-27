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

                Meta().charset(context.charset)
                Meta().name(.viewport).content(context.viewport)

                for file in context.css {
                    Link(rel: .stylesheet).href(file)
                }
            }
            Body {
                Div {
                    A {
                        Img(src: "/img/web/logo.png", alt: "Logo of Feather CMS")
                            .title("Feather CMS")
                            .style("width: 300px")
                    }
                    .href("/")
                    
                    Nav {
                        Input()
                            .type(.checkbox)
                            .id("secondary-menu-button")
                            .name("menu-button")
                            .class("menu-button")
                        Label {
                            Svg {
                                Circle(cx: 12, cy: 12, r: 1)
                                Circle(cx: 12, cy: 5, r: 1)
                                Circle(cx: 12, cy: 19, r: 1)
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
                        .for("secondary-menu-button")

                        Div {
                            A("Sign out")
                                .href(Feather.config.paths.logout.safePath())
//                                .class("selected", req.url.path == "/")
                        }
                        .class("menu-items")
                    }
                    .id("secondary-menu")
                }
                .id("navigation")
                
                Div {
                    Nav {
                        if req.checkPermission(Admin.permission(for: .detail)) {
                            A("Admin")
                                .href(Feather.config.paths.admin.safePath())
                        }
                        
                        context.breadcrumbs.compactMap { $0.render(req) }
                    }
                }
                .class("breadcrumb")

                Main {
                    body
                }
                
                Footer {
                    Section {
                        Img(src: "/img/web/logo.png", alt: "Logo of Feather CMS")
                            .title("Feather CMS")
                            .style("width: 128px")

                        P {
                            Text("Thank you for using Feather CMS, ")
                            A("join the discussion")
                                .href("https://discord.gg/wMSkxCUXAD")
                                .target(.blank)
                            Text(" on our discord server.")
                        }
                        
                        Nav {
                            A("Feather")
                                .href("https://feathercms.com/")
                                .target(.blank)
                            Text(" · ")
                            A("Vapor")
                                .href("https://vapor.codes/")
                                .target(.blank)
                            Text(" · ")
                            A("Swift")
                                .href("https://swift.org/")
                                .target(.blank)
                        }
                    }
                }
                
            }
        }
        .lang(context.lang)
    }
    
}
