//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 26..
//

import SwiftHtml

struct MetaContext {
    let charset: String
    let viewport: String
    let noindex: Bool
}

struct MetaTemplate: TemplateRepresentable {
    
    let context: MetaContext
    
    init(_ context: MetaContext) {
        self.context = context
    }
    
    @TagBuilder
    func render(_ req: Request) -> Tag {
        Meta()
            .charset(context.charset)

        Meta()
            .name(.viewport)
            .content(context.viewport)

        Meta()
            .name(.colorScheme)
            .content("light dark")
        Meta()
            .name(.themeColor)
            .content("#fff")
            .media(.prefersColorScheme(.light))
        Meta()
            .name(.themeColor)
            .content("#000")
            .media(.prefersColorScheme(.dark))

        if context.noindex {
            Meta()
                .name(.robots)
                .content("noindex")
        }
    }
}





