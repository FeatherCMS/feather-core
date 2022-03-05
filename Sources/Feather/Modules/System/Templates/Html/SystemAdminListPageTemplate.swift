//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

import Vapor
import SwiftHtml

struct SystemAdminListPageTemplate: TemplateRepresentable {
    
    var context: SystemAdminListPageContext

    init(_ context: SystemAdminListPageContext) {
        self.context = context
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        SystemAdminIndexTemplate(.init(title: context.title, breadcrumbs: context.breadcrumbs)) {
            Wrapper {
                LeadTemplate(.init(title: context.title, links: context.navigation)).render(req)
                
                if context.isSearchable && (req.hasQuery("search") || !context.table.rows.isEmpty) {
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
                            P("There are no results for the given search term.")
                            A("Try again →")
                                .href(req.url.path)
                        }
                        .class("list-search-empty-results")
                    }
                    else {
                        P("There are no items in this list just yet.")
                    }
                    
                }
                else {
                    TableTemplate(context.table).render(req)
                }
                PaginationTemplate(context.pagination).render(req)
            }
        }
        .render(req)
    }
}
