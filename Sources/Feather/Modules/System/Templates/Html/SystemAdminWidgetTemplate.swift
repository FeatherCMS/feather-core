//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import SwiftHtml
import FeatherApi
import FeatherIcons

struct SystemAdminWidgetTemplate: TemplateRepresentable {
 
    @TagBuilder
    func render(_ req: Request) -> Tag {
        Svg.command
        H2("System")
        Ul {
            if req.checkPermission(FeatherFile.permission(for: .list)) {
                Li {
                    A("Files")
                        .href("/admin/system/files/")
                }
            }
            if req.checkPermission(FeatherVariable.permission(for: .list)) {
                Li {
                    A("Variables")
                        .href("/admin/system/variables/")
                }
            }
            if req.checkPermission(FeatherPermission.permission(for: .list)) {
                Li {
                    A("Permissions")
                        .href("/admin/system/permissions")
                }
            }
            if req.checkPermission(FeatherMetadata.permission(for: .list)) {
                Li {
                    A("Metadatas")
                        .href("/admin/system/metadatas")
                }
            }
        }
    }
}
