//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor
import SwiftHtml

struct UserAdminWidgetTemplate: TemplateRepresentable {
 
    unowned var req: Request
    
    init(_ req: Request) {
        self.req = req
    }

    @TagBuilder
    var tag: Tag {
        H2("User")
        Ul {
            Li {
                A("Accounts")
                    .href("user/accounts")
            }
            Li {
                A("Roles")
                    .href("user/roles")
            }
            Li {
                A("Permissions")
                    .href("user/permissions")
            }
        }
    }
}
