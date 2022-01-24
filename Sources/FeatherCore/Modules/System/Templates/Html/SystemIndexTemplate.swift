//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 15..
//

import SwiftHtml
import SwiftSvg

public struct SystemIndexTemplate: TemplateRepresentable {

    public var context: WebIndexContext
    var body: Tag

    public init(_ context: WebIndexContext, @TagBuilder _ builder: () -> Tag) {
        self.context = context
        self.body = builder()
    }

    @TagBuilder
    public func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title(context.title)

                Meta()
                    .charset(context.charset)
                
                Meta()
                    .name(.viewport)
                    .content(context.viewport)

                Meta()
                    .name(.robots)
                    .content("noindex")


                for file in context.css {
                    Link(rel: .stylesheet)
                        .href(file)
                }

            }
            Body {
                Header {
                    Div {
                        A {
                            Picture {
                                Source()
                                    .srcset("/img/web/logos/feather-logo-dark.png")
                                    .media(.prefersColorScheme(.dark))
                                Img(src: "/img/web/logos/feather-logo.png", alt: "Logo of Feather CMS")
                                    .title("Feather CMS")
                                    .style("width: 300px")
                            }
                        }
                        .href("/")
                    }
                    .id("navigation")
                }
                
                Main {
                    Div {
                        body
                    }
                    .class("container")
                }
            }
        }
        .lang(context.lang)
    }
    
}
