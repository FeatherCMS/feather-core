//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 25..
//

import SwiftHtml

struct OgMetaContext {
    let url: String
    let title: String
    let excerpt: String?
    let imageUrl: String?
}

struct OgMetaTemplate: TemplateRepresentable {
    
    let context: OgMetaContext
    
    init(_ context: OgMetaContext) {
        self.context = context
    }
    
    @TagBuilder
    func render(_ req: Request) -> Tag {
        
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



