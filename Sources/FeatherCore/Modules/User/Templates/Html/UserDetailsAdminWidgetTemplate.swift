//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import SwiftHtml

struct UserDetailsAdminWidgetTemplate: TemplateRepresentable {
 
    @TagBuilder
    func render(_ req: Request) -> Tag {
        H2("Admin")
        Ul {
            Li(req.auth.get(FeatherAccount.self)?.email ?? "unknown")
            Li {
                A("Sign out")
                    .href("/" + Feather.config.paths.logout)
            }
        }
    }
}
