//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import SwiftHtml
import FeatherIcons

struct UserAdminWidgetTemplate: TemplateRepresentable {
    
    @TagBuilder
    func render(_ req: Request) -> Tag {
        Svg.user
        H2("User")
        Ul {
            if req.checkPermission(User.Account.permission(for: .list)) {
                Li {
                    A("Accounts")
                        .href("/admin/user/accounts")
                }
            }
            if req.checkPermission(User.Role.permission(for: .list)) {
                Li {
                    A("Roles")
                        .href("/admin/user/roles")
                }
            }
            if req.checkPermission(User.Permission.permission(for: .list)) {
                Li {
                    A("Permissions")
                        .href("/admin/user/permissions")
                }
            }
        }
    }
}
