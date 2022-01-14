//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//

import SwiftHtml

public struct LinkTemplate: TemplateRepresentable {

    var context: LinkContext
    var body: Tag
    var pathInfix: String?

    public init(_ context: LinkContext, pathInfix: String? = nil, _ builder: ((String) -> Tag)? = nil) {
        self.context = context
        self.pathInfix = pathInfix
        self.body = builder?(context.label) ?? Text(context.label)
    }

    @TagBuilder
    public func render(_ req: Request) -> Tag {
        if !req.checkPermission(context.permission) {
            Text("") // @NOTE: this is a bit of a hack, but we don't want to render anything
        }
        A { body }
            .href(context.url(req, pathInfix?.pathComponents ?? []))
            .target(.blank, context.isBlank)
            .class(context.style.rawValue)
    }
}
