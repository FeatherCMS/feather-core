//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import SwiftHtml

struct UserDetailsAdminWidgetTemplate: TemplateRepresentable {
 
    unowned var req: Request
    
    init(_ req: Request) {
        self.req = req
    }
   
    var user: FeatherUser? {
        req.auth.get(FeatherUser.self)
    }

    @TagBuilder
    var tag: Tag {
        H2("Admin")
        Ul {
            Li(user?.email ?? "unknown")
            Li {
                A("Sign out")
                    .href("/" + Feather.config.paths.logout)
            }
        }
    }
}
