//
//  RedirectAdminWidgetTemplate.swift
//  
//
//  Created by Steve Tibbett on 2021-12-19
//

import Vapor
import SwiftHtml

struct RedirectAdminWidgetTemplate: TemplateRepresentable {
    
    unowned var req: Request
    
    init(_ req: Request) {
        self.req = req
    }
    
    @TagBuilder
    var tag: Tag {
        H2("Redirect")
        Ul {
            if RedirectRuleAdminController.hasListPermission(req) {
                Li {
                    A("Rules")
                        .href("/admin/redirect/rules/")
                }
            }
        }
    }
}
