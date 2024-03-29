//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import SwiftHtml
import FeatherIcons

struct CommonAdminWidgetTemplate: TemplateRepresentable {

    @TagBuilder
    func render(_ req: Request) -> Tag {
        Svg.package
        H2("Common")
        Ul {
            if req.checkPermission(Common.Variable.permission(for: .list)) {
                Li {
                    A("Variables")
                        .href("/admin/common/variables/")
                }
            }
            Li {
                A("Files")
                    .href("/admin/common/files/")
            }
        }
    }
}
