//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

import Vapor
import SwiftHtml

public struct TableTemplate: TemplateRepresentable {
    
    unowned var req: Request
    var context: TableContext
    var rowId: String

    public init(_ req: Request, _ context: TableContext, rowId: String = ":rowId") {
        self.req = req
        self.context = context
        self.rowId = rowId
    }
    
    func css() -> String {
        /// NOTE: col.width support
        let size = context.columns.count + context.actions.count
        let w = (0..<size).map { _ in "1fr" }.joined(separator: " ")
        return """
        tr {
            grid-template-columns: repeat(#max(1, \(size), 1fr);
        }
        td.field {
            grid-column: span \(size);
        }
        @media (min-width: 600px) {
            tr {
                grid-template-columns: \(w);
            }
            td.field {
                grid-column: span 1;
            }
        }
        """
    }

    @TagBuilder
    public var tag: Tag {
        SwiftHtml.Style(css())
            .type()

        Table {
            Thead {
                Tr {
                    for column in context.columns {
                        Th {
                            if context.options.allowedOrders.contains(column.key) {
                                SortingTemplate(req, .init(key: column.key,
                                                           label: column.label,
                                                           isDefault: context.options.allowedOrders.first == column.key,
                                                           sort: context.options.defaultSort)).tag
                            }
                            else {
                                Text(column.label)
                            }
                        }
                        .id(column.key)
                        .class("field")
                    }
                    context.actions.compactMap { action in
                        guard req.checkPermission(action.permission) else {
                            return nil
                        }
                        return Th(action.label)
                        .class("field")
                    }
                }
            }
            Tbody {
                for row in context.rows {
                    Tr {
                        for cell in row.cells {
                            Td {
                                if let value = cell.value {
                                    switch cell.type {
                                    case .text:
                                        if let link = cell.link {
                                            if req.checkPermission(link.permission) {
                                                A(link.label)
                                                    .href(link.url.replacingOccurrences(of: rowId, with: row.id))
                                            }
                                            else {
                                                Text(link.label)
                                            }
                                        }
                                        else {
                                            Text(value)
                                        }
                                    case .image:
                                        if let link = cell.link {
                                            if req.checkPermission(link.permission) {
                                                A {
                                                    Img(src: req.fs.resolve(key: value), alt: link.label)
                                                }
                                                .href(link.url.replacingOccurrences(of: rowId, with: row.id))
                                            }
                                            else {
                                                Img(src: req.fs.resolve(key: value), alt: link.label)
                                            }
                                        }
                                        else {
                                            Img(src: req.fs.resolve(key: value), alt: row.id)
                                        }
                                    }
                                }
                            }
                            .class("field")
                        }

                        context.actions.compactMap { action in
                            guard req.checkPermission(action.permission) else {
                                return nil
                            }
                            return Td {
                                A(action.label)
                                    .href(action.url.replacingOccurrences(of: rowId, with: row.id))
                            }
                            .class("field")
                        }
                    }
                    .id(row.id)
                }
            }
        }
    }
}


