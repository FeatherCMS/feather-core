//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor
import SwiftHtml

struct CommonAdminWidgetTemplate: TemplateRepresentable {
    
    unowned var req: Request
    
    init(_ req: Request) {
        self.req = req
    }

    @TagBuilder
    var tag: Tag {
        H2("Common")
        Ul {
            Li {
                A("Variables")
                    .href("common/variables/")
            }
        }
    }
}
