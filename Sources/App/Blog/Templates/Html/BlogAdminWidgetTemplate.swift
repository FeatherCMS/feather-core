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
            if BlogPostAdminController.hasListPermission(req) {
                Li {
                    A("Posts")
                        .href("/admin/blog/posts/")
                }
            }
            if BlogCategoryAdminController.hasListPermission(req) {
                Li {
                    A("Categories")
                        .href("/admin/blog/categories/")
                }
            }
            if BlogAuthorAdminController.hasListPermission(req) {
                Li {
                    A("Authors")
                        .href("/admin/blog/authors/")
                }
            }
        }
    }
}
