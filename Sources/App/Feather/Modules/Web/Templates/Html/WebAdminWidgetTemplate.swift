//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import SwiftHtml

struct WebAdminWidgetTemplate: TemplateRepresentable {
 
    unowned var req: Request
    
    init(_ req: Request) {
        self.req = req
    }

    @TagBuilder
    var tag: Tag {
        H2("Web")
        Ul {
            Li {
                A("Pages")
                    .href("web/pages")
            }
            Li {
                A("Menus")
                    .href("web/menus")
            }
            Li {
                A("Metadatas")
                    .href("web/metadatas")
            }
        }
    }
}
