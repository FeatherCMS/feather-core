//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 15..
//

import Vapor
import SwiftHtml

struct WebIndexTemplate: TemplateRepresentable {
    
    struct Context {
        struct Metadata {
            var title: String
            var description: String
            var url: String
            var image: String
        }
        
        struct User {
            let email: String
        }

        var title: String
        var css: [String] = ["/css/global.css", "/style.css"]
        var js: [String] = []
        var lang: String = "en"
        var charset: String = "utf-8"
        var viewport: String = "width=device-width, initial-scale=1"
        var noindex: Bool = false
        var metadata: Metadata? = nil
        var canonicalUrl: String? = nil
        var user: User? = nil
    }

    unowned var req: Request
    var context: Context
    var body: Tag

    init(_ req: Request, context: Context, @TagBuilder _ builder: () -> Tag) {
        self.req = req
        self.context = context
        self.body = builder()
    }

    var tag: Tag {
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
                                        .href($0.url)
                                        .class("selected", req.url.path == $0.url)
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
                            if let user = req.auth.get(FeatherUser.self) {
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
