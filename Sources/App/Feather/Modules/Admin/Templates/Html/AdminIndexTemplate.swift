//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 15..
//

import Vapor
import SwiftHtml

public struct AdminIndexTemplate: TemplateRepresentable {

    unowned var req: Request
    var context: AdminIndexContext
    var body: Tag

    public init(_ req: Request, _ context: AdminIndexContext, @TagBuilder _ builder: () -> Tag) {
        self.req = req
        self.context = context
        self.body = builder()
    }

    public var tag: Tag {
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
                        Img(src: "/img/logo.png", alt: "Logo of Feather CMS")
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
                            A("test")
                                .href("asdf")
                                .class("selected", req.url.path == "/")
                            
                            A("Sign out")
                                .href("/logout/")
                                .class("selected", req.url.path == "/")
                        }
                        .class("menu-items")
                    }
                    .id("secondary-menu")
                }
                .id("navigation")
                
                Div {
                    Nav {
                        A("Admin")
                            .href("/admin/")
                        
                        context.breadcrumbs.map { item in
                            A(item.label)
                                .href(item.url)
                        }
                    }
                }
                .class("breadcrumb")

                Main {
                    body
                }
                
                Footer {
                    Section {
                        Img(src: "/img/logo.png", alt: "Logo of Feather CMS")
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