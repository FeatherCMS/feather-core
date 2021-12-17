//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

import Vapor
import SwiftHtml

public struct AdminDashboardTemplate: TemplateRepresentable {
    
    unowned var req: Request
    var context: AdminDashboardContext
    
    public init(_ req: Request, _ context: AdminDashboardContext) {
        self.req = req
        self.context = context
    }

    public var tag: Tag {
        AdminIndexTemplate(req, .init(title: context.title)) {
            Div {
                H1("Dashboard")
                P("Overview of the content management system.")
            }
            .class("lead")
            
            Section {
                context.widgets.map { widget in
                    Div {
                        Div {
                            widget
                        }
                        .class("content")
                    }
                    .class("card")
                }
            }
            .class("grid-321")
        }.tag
    }
}
