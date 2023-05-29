//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 25..
//

import Vapor
import SwiftHtml

// https://ogp.me
public struct OpenGraphMetaTemplate: TemplateRepresentable {
    
    public let context: OpenGraphMetaContext
    
    public init(_ context: OpenGraphMetaContext) {
        self.context = context
    }
    
    @TagBuilder
    public func render(_ req: Request) -> Tag {
        
        Meta()
            .name("og:url")
            .content(context.url)
        Meta()
            .name("og:title")
            .content(context.title)

        if let excerpt = context.excerpt, !excerpt.isEmpty {
            Meta()
                .name("og:description")
                .content(excerpt)
        }
        if let url = context.imageUrl, !url.isEmpty {
            Meta()
                .name("og:image")
                .content(url)
        }
    }
}



