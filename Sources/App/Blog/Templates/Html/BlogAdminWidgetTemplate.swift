//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 16..
//

import Vapor
import FeatherCore
import SwiftHtml

struct BlogAdminWidgetTemplate: TemplateRepresentable {
    
    unowned var req: Request
    
    init(_ req: Request) {
        self.req = req
    }
    
    @TagBuilder
    var tag: Tag {
        H2("Blog")
        Ul {
            if BlogCategoryAdminController.hasListPermission(req) {
                Li {
                    A("Categories")
                        .href(BlogCategoryAdminController.listPath)
                }
            }
            if req.checkPermission("blog-category-list") {
                Li {
                    A("Categories")
                        .href("blog/categories")
                }
            }
            if req.checkPermission("blog-author-list") {
                Li {
                    A("Authors")
                        .href("blog/authors")
                }
            }
        }
    }
}
