//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 26..
//

import SwiftHtml

public struct StandardMetaTemplate: TemplateRepresentable {
    
    public let context: StandardMetaContext
    
    public init(_ context: StandardMetaContext) {
        self.context = context
    }
    
    @TagBuilder
    public func render(_ req: Request) -> Tag {
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





