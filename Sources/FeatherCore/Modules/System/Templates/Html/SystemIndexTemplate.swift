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
                Title(context.title + " - " + "Feather")

                StandardMetaTemplate(.init(charset: context.charset,
                                   viewport: context.viewport,
                                   noindex: true)).render(req)

                for file in context.css {
                    Link(rel: .stylesheet)
                        .href(file)
                }
            }
            Body {
                HeaderTemplate(.init()).render(req)
                MainTemplate(.init(body: body)).render(req)
                FooterTemplate(.init(displayTopSection: false)).render(req)
            }
        }
        .lang(context.lang)
    }
}
