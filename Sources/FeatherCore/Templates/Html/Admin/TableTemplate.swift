//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

import SwiftHtml

public struct TableTemplate: TemplateRepresentable {
    
    var context: TableContext

    public init(_ context: TableContext) {
        self.context = context
    }
    
    func availableActions(_ req: Request) -> [LinkContext] {
        // @NOTE: cache?
        context.actions.compactMap { action -> LinkContext? in
            guard req.checkPermission(action.permission) else {
                return nil
            }
            return action
        }
    }
    
    func css(_ req: Request) -> String {
        /// @NOTE: col.width support
        let size = context.columns.map { _ in "1fr" } + availableActions(req).map { _ in "4rem" }
        return """
        tr {
            grid-template-columns: repeat(\(max(1, availableActions(req).count)), 1fr);
        }
        td.field {
            grid-column: span \(availableActions(req).count);
        }
        @media (min-width: 600px) {
            tr {
                grid-template-columns: \(size.joined(separator: " "));
            }
            td.field {
                grid-column: span 1;
            }
        }
        """
    }

    @TagBuilder
    public func render(_ req: Request) -> Tag {
        SwiftHtml.Style(css(req)).css()

        Table {
            Thead {
                Tr {
                    for column in context.columns {
                        Th {
                            if context.options.allowedOrders.contains(column.key) {
                                SortingTemplate(.init(key: column.key,
                                                      label: column.label,
                                                      isDefault: context.options.allowedOrders.first == column.key,
                                                      defaultSort: context.options.defaultSort)).render(req)
                            }
                            else {
                                Text(column.label)
                            }
                        }
                        .id(column.key)
                        .class("field")
                    }
                    availableActions(req).map { action in
                        Th(action.label)
                            .class("action")
                    }
                }
            }
            Tbody {
                for row in context.rows {
                    Tr {
                        for cell in row.cells {
                            CellTemplate(cell, rowId: row.id).render(req)
                        }

                        availableActions(req).map { action in
                            Td {
                                A(action.label)
                                    .href(action.url(req, row.id.pathComponents))
                                    .target(.blank, action.isBlank)
                                    .class(action.style.rawValue)
                            }
                            .class("action")
                        }
                    }
                    .id(row.id)
                }
            }
        }
    }
}


