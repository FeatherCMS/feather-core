//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import SwiftHtml

struct CommonAdminWidgetTemplate: TemplateRepresentable {

    @TagBuilder
    func render(_ req: Request) -> Tag {
        H2("Common")
        Ul {
            if req.checkPermission(Common.Variable.permission(for: .list)) {
                Li {
                    A("Variables")
                        .href("common/variables/")
                }
            }
            Li {
                A("Files")
                    .href("common/files/")
            }
        }
    }
}
