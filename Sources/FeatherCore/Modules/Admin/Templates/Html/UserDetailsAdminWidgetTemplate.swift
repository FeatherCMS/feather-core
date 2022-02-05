//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import SwiftHtml
import FeatherIcons

struct AdminDetailsWidgetTemplate: TemplateRepresentable {
 
    @TagBuilder
    func render(_ req: Request) -> Tag {
        Svg.icon(.command)
        H2("Admin")
        Ul {
            Li(req.auth.get(FeatherAccount.self)?.email ?? "unknown")
            Li {
                A("View site")
                    .href("/")
            }
            Li {
                A("Sign out")
                    .href("/" + req.feather.config.paths.logout)
            }
        }
    }
}
