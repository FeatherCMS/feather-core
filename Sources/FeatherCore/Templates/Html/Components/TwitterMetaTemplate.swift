//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 25..
//

import SwiftHtml

struct TwitterMetaContext {
    let title: String
    let excerpt: String?
    let imageUrl: String?
}

struct TwitterMetaTemplate: TemplateRepresentable {
    
    let context: TwitterMetaContext
    
    init(_ context: TwitterMetaContext) {
        self.context = context
    }
    
    @TagBuilder
    func render(_ req: Request) -> Tag {

        Meta()
            .name("twitter:card")
            .content("summary_large_image")

        Meta()
            .name("twitter:title")
            .content(context.title)

        if let excerpt = context.excerpt, !excerpt.isEmpty {
            Meta()
                .name("twitter:description")
                .content(excerpt)
        }
        if let url = context.imageUrl, !url.isEmpty {
            Meta()
                .name("twitter:image")
                .content(url)
        }
    }
}

