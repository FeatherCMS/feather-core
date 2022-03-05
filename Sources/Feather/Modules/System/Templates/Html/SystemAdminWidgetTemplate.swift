//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import SwiftHtml
import FeatherIcons

struct SystemAdminWidgetTemplate: TemplateRepresentable {
 
    @TagBuilder
    func render(_ req: Request) -> Tag {
        Svg.command
        H2("System")
        Ul {
            Li {
                A("Settings")
                    .href("/admin/system/settings")
            }

            Li {
                A("Files")
                    .href("/admin/system/files/")
            }
            
            if req.checkPermission(FeatherApi.System.Permission.permission(for: .list)) {
                Li {
                    A("Permissions")
                        .href("/admin/system/permissions")
                }
            }
            if req.checkPermission(FeatherApi.System.Variable.permission(for: .list)) {
                Li {
                    A("Variables")
                        .href("/admin/system/variables/")
                }
            }
            if req.checkPermission(FeatherApi.System.Metadata.permission(for: .list)) {
                Li {
                    A("Metadatas")
                        .href("/admin/system/metadatas")
                }
            }
        }
    }
}
