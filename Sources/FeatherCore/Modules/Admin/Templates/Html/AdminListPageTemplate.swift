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
                Div {
                    H1(context.title)
                    P {
                        context.navigation.map { LinkTemplate($0).render(req) }
                    }
                }
                .class("lead")
                
                if context.isSearchable && !context.table.rows.isEmpty {
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
                    if req.hasQuery("search") {
                        Div {
                            Span("🔍")
                                .class("icon")
                            H2("Oh no")
                            P("This list is empty right now.")
                            A("Try again →")
                                .href(req.url.path)
                                .class("button-1")
                        }
                        .class(["lead", "container", "center"])
                    }
                    else {
                        Div {
                            Span("🤔")
                                .class("icon")
                            H2("Seems like")
                            P("There are not list items just yet.")
                        }
                        .class(["lead", "container", "center"])
                    }
                }
                else {
                    TableTemplate(context.table).render(req)
                }
                PaginationTemplate(context.pagination).render(req)
            }
            .class("wrapper")
        }
        .render(req)
    }
}
