//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Vapor
import FeatherCore
import SwiftHtml

struct BlogCategoryPageTemplate: TemplateRepresentable {
    
    unowned var req: Request
    var context: BlogCategoryPageTemplateContext
    
    init(_ req: Request, context: BlogCategoryPageTemplateContext) {
        self.req = req
        self.context = context
    }

    
    @TagBuilder
    var tag: Tag {
        WebIndexTemplate.init(req, context: .init(title: context.category.title)) {
            Div {
                Header {
                    H1(context.category.title)
                    P(context.category.excerpt ?? "")
                }
                .class("lead")
                
                Section {
                    for post in context.posts {
                        A("")
                            .href(post)
    //                    <a href="/#(category.metadata.slug)" class="card">
    //                        <div class="content">
    //                            #if(category.imageKey != nil):
    //                            <img style="width: 4rem;" src="#(category.imageKey.resolve())">
    //                            #endif
    //                            <h2#if(category.color != nil): style="color: #(category.color);"#endif>#(category.title)</h2>
    //                            <p>#(category.excerpt)</p>
    //                        </div>
    //                    </a>
                    }
                }
            }
            .id("blog-categories")
            .class("container")
        }.tag
    }
}

