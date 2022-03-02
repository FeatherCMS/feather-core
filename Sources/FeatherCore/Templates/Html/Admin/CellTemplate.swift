//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//

import SwiftHtml

public struct CellTemplate: TemplateRepresentable {
    
    var context: CellContext
    var rowId: String

    public init(_ context: CellContext, rowId: String) {
        self.context = context
        self.rowId = rowId
    }

    @TagBuilder
    public func render(_ req: Request) -> Tag {
        Td {
            switch context.type {
            case .text:
                if let link = context.link {
                    if req.checkPermission(link.permission) {
                        LinkTemplate(link, pathInfix: rowId).render(req)
                    }
                    else {
                        Text(link.label)
                    }
                }
                else {
                    Text(context.value ?? "&nbsp;")
                }
            case .image:
                if let link = context.link {
                    if req.checkPermission(link.permission) {
                        LinkTemplate(link, pathInfix: rowId) { [unowned req] label in
                            if let value = context.value, !value.isEmpty {
                                return Img(src: req.fs.resolve(key: value), alt: label)
                            }
                            return Text("&nbsp;")
                        }
                        .render(req)
                    }
                    else {
                        if let value = context.value, !value.isEmpty {
                            Img(src: req.fs.resolve(key: value), alt: link.label)
                        }
                        else {
                            Text("&nbsp;")
                        }
                    }
                }
                else {
                    if let value = context.value, !value.isEmpty {
                        Img(src: req.fs.resolve(key: value), alt: value)
                    }
                    else {
                        Text("&nbsp;")
                    }
                }
            }
        }
        .class("image", context.type == .image)
    }
}
