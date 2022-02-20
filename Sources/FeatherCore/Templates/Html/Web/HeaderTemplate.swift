//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 24..
//

import SwiftHtml
import FeatherIcons

public struct HeaderTemplate: TemplateRepresentable {
    
    public let context: HeaderContext
    
    public init(_ context: HeaderContext) {
        self.context = context
    }
    
    public func render(_ req: Request) -> Tag {
        Header {
            Div {
                A {
                    Picture {
                        Source()
                            .srcset(getLogoUrl(req, darkMode: true))
                            .media(.prefersColorScheme(.dark))
                        Img(src: getLogoUrl(req), alt: "Logo of \(context.title)")
                            .title(context.title)
                    }
                }
                .id("site-logo")
                .href(context.logoLink)
                
                if let main = context.main {
                    NavigationTemplate(main).render(req)
                }
  
                if let action = context.action {
                    Nav {
                        A {
                            action.icon
                            Span(action.title)
                        }
                            .class("button")
                            .href(action.link)
                        }
                    .class("action-item")
                }
            }
            .class("safe-area")
        }
        .id("navigation")
        .class("noselect")
    }
}


private extension HeaderTemplate {

    func getLogoUrl(_ req: Request, darkMode: Bool = false) -> String {
        if darkMode {
            if let logo = req.variable("webSiteLogoDark"), !logo.isEmpty {
                return req.fs.resolve(key: logo)
            }
            return "/img/\(context.assets)/logos/logo-dark.png"
        }
        if let logo = req.variable("webSiteLogo"), !logo.isEmpty {
            return req.fs.resolve(key: logo)
        }
        return "/img/\(context.assets)/logos/logo.png"
    }
}
