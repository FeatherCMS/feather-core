//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

import SwiftHtml

public struct AdminListPageTemplate: TemplateRepresentable {
    
    var context: AdminListPageContext

    public init(_ context: AdminListPageContext) {
        self.context = context
    }

    @TagBuilder
    public func render(_ req: Request) -> Tag {
        AdminIndexTemplate(.init(title: context.title, breadcrumbs: context.breadcrumbs)) {
            Div {
                H1(context.title)
                P {
                    context.navigation.map { LinkTemplate($0).render(req) }
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
                TableTemplate(context.table).render(req)
            }
            PaginationTemplate(context.pagination).render(req)
        }
        .render(req)
    }
}
