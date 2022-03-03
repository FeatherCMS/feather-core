//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 09..
//

import SwiftHtml

public struct FooterTemplate: TemplateRepresentable {
    
    public let context: FooterContext
    
    public init(_ context: FooterContext) {
        self.context = context
    }


    public func render(_ req: Request) -> Tag {
        Footer {
            Div {
                if context.displayTopSection {
                    Wrapper {
                        Div {
                            (1...4).compactMap { renderSection(req, "footer-\($0)") }
                        }
                        .class("grid-421")
                    }
                }
                    
                P("\(getTitle(req)) &copy; \(Calendar.current.component(.year, from: Date()))")
            }
            .class("safe-area")
        }
    }
}

private extension FooterTemplate {
    
    func getTitle(_ req: Request) -> String {
        req.variable("webSiteTitle") ?? "Feather"
    }
    
    func renderMenu(_ req: Request, _ items: [LinkContext]) -> Tag {
        Ul {
            items.filter { item -> Bool in
                if let permission = item.permission {
                    return req.checkPermission(permission)
                }
                return true
            }
            .map { ctx -> Tag in
                Li {
                    LinkTemplate(ctx).render(req)
                }
            }
        }
    }
    
    func renderSection(_ req: Request, _ id: String) -> Tag? {
        var arguments = HookArguments()
        arguments["menu-id"] = id
        let ctx: MenuContext? = req.invokeAllFirst(.webMenu, args: arguments)
        guard let menu = ctx else {
            return nil
        }
        return Section {
            H4(menu.name)
            renderMenu(req, menu.items)
        }
    }
}
