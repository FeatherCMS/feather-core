//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

import Vapor
import SwiftHtml



public struct AdminListPageTemplate: TemplateRepresentable {
    
    unowned var req: Request
    var context: AdminListPageContext

    public init(_ req: Request, _ context: AdminListPageContext) {
        self.req = req
        self.context = context
    }

    public var tag: Tag {
        AdminIndexTemplate(req, .init(title: context.title, breadcrumbs: context.breadcrumbs)) {
            Div {
                H1(context.title)
                P {
                    context.navigation.compactMap { $0.render(req) }
                }
            }
            .class("lead")
            
            if context.isSearchable {
                Form {
                    Input()
                        .type(.text)
                        .key("search")
                        .placeholder("Search...")
                        .value(req.getQuery("search"))

                    if let sort = req.getQuery("sort") {
                        Input()
                            .type(.hidden)
                            .key("sort")
                            .value(sort)
                    }
                    if let order = req.getQuery("order") {
                        Input()
                            .type(.hidden)
                            .key("order")
                            .value(order)
                    }
                }
                .id("list-search-form")
                .action(req.url.path)
                .method(.get)
            }
            
            if context.table.rows.isEmpty {
                Div {
                    Span(req.variable("emptyListIcon") ?? "🔍")
                        .class("icon")
                    H2(req.variable("emptyListTitle") ?? "Oh no")
                    P(req.variable("emptyListDescription") ?? "This list is empty right now.")
                    A(req.variable("emptyListLinkLabel") ?? "Try again →")
                        .href(req.url.path)
                        .class("button-1")
                }
                .class(["lead", "container", "center"])
            }
            else {
                TableTemplate(req, context.table).tag
            }
            PaginationTemplate(req, context.pagination).tag
        }.tag
    }
}
