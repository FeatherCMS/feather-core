//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import SwiftHtml
import FeatherIcons

struct WebAdminWidgetTemplate: TemplateRepresentable {
 
    @TagBuilder
    func render(_ req: Request) -> Tag {
        Svg.icon(.compass)

        H2("Web")
        Ul {
            if req.checkPermission(Web.Page.permission(for: .list)) {
                Li {
                    A("Pages")
                        .href("web/pages")
                }
            }
            if req.checkPermission(Web.Menu.permission(for: .list)) {
                Li {
                    A("Menus")
                        .href("web/menus")
                }
            }
            if req.checkPermission(Web.Metadata.permission(for: .list)) {
                Li {
                    A("Metadatas")
                        .href("web/metadatas")
                }
            }
            Li {
                A("Settings")
                    .href("web/settings")
            }
        }
    }
}
