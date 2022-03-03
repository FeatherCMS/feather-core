//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 15..
//

import SwiftHtml
import SwiftSvg

public final class SystemIndexTemplate: AbstractTemplate<SystemIndexContext> {

    var body: Tag

    public init(_ context: SystemIndexContext, @TagBuilder _ builder: () -> Tag) {
        self.body = builder()
        super.init(context)
    }

    @TagBuilder
    public override func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title(getTitle())

                StandardMetaTemplate(.init(charset: context.charset,
                                   viewport: context.viewport,
                                   noindex: true)).render(req)

                for file in context.css {
                    Link(rel: .stylesheet)
                        .href(file)
                }
            }
            Body {
                HeaderTemplate(.init(title: getTitle(),
                                     main: .init(id: "main",
                                                 icon: Text("&#9776;"),
                                                 items: mainMenuItems(req)),
                                     assets: "system")).render(req)
                MainTemplate(.init(body: body)).render(req)
                FooterTemplate(.init(displayTopSection: true)).render(req)
            }
        }
        .lang(context.lang)
    }
}

private extension SystemIndexTemplate {
    func getTitle() -> String {
        context.title + " - " + "Feather"
    }
    
    func mainMenuItems(_ req: Request) -> [Tag] {
        var arguments = HookArguments()
        arguments["menu-id"] = "main"
        let ctx: MenuContext? = req.invokeAllFirst(.webMenu, args: arguments)
        return ctx?.items.map {
            A($0.label)
                .href($0.path)
                .class("selected", req.url.path == $0.path)
        } ?? []
    }
}
