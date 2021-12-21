//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 15..
//

import Vapor
import SwiftHtml
import SwiftSvg

public struct WebIndexTemplate: TemplateRepresentable {

    unowned var req: Request
    public var context: WebIndexContext
    var body: Tag

    public init(_ req: Request, context: WebIndexContext, @TagBuilder _ builder: () -> Tag) {
        self.req = req
        self.context = context
        self.body = builder()
    }

    public var tag: Tag {
        Html {
            Head {
                Title(context.title)

                Meta()
                    .charset(context.charset)
                
                Meta()
                    .name(.viewport)
                    .content(context.viewport)

                if context.noindex {
                    Meta()
                        .name(.robots)
                        .content("noindex")
                }

                for file in context.css {
                    Link(rel: .stylesheet)
                        .href(file)
                }
                
                if let canonicalUrl = context.canonicalUrl {
                    Link(rel: .canonical)
                        .href(canonicalUrl)
                }
            }
            Body {
                Header {
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
                            if let user = req.auth.get(UserAccount.self) {
                                P(user.email)
                                A("Sign out")
                                    .href("/logout/")
                            }
                            else {
                                if req.url.path != "/login/" {
                                    A("Sign in")
                                        .href("/login/")
                                }
                            }
                        }
                    }
                }

                for file in context.js {
                    Script()
                        .type(.javascript)
                        .src(file)
                }
            }
        }
        .lang(context.lang)
    }
    
}
