//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import SwiftHtml

struct UserAdminWidgetTemplate: TemplateRepresentable {
    
    @TagBuilder
    func render(_ req: Request) -> Tag {
        H2("User")
        Ul {
            if req.checkPermission(User.Account.permission(for: .list)) {
                Li {
                    A("Accounts")
                        .href("user/accounts")
                }
            }
            if req.checkPermission(User.Role.permission(for: .list)) {
                Li {
                    A("Roles")
                        .href("user/roles")
                }
            }
            if req.checkPermission(User.Permission.permission(for: .list)) {
                Li {
                    A("Permissions")
                        .href("user/permissions")
                }
            }
        }
    }
}
