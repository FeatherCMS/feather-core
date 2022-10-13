//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//

import Vapor
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
                        Text(context.value ?? link.label)
                    }
                }
                else {
                    Text(context.value ?? "&nbsp;")
                }
            case .image:
                if let link = context.link {
                    if req.checkPermission(link.permission) {
                        LinkTemplate(link, pathInfix: rowId) { [unowned req] _ in
                            getImageTag(req)
                        }
                        .render(req)
                    }
                    else {
                        getImageTag(req)
                    }
                }
                else {
                    getImageTag(req)
                }
            }
        }
        .class("image", context.type == .image)
    }

    private func getImageTag(_ req: Request) -> Tag {
        if let value = context.value, !value.isEmpty {
            return Img(src: req.fs.resolve(key: value), alt: context.link?.label ?? value)
        }
        if let placeholder = context.placeholder {
            return Img(src: placeholder, alt: context.link?.label ?? placeholder)
        }
        return Text("&nbsp;")
    }
}
