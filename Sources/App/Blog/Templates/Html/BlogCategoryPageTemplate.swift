//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Vapor
import Liquid
import FeatherCore
import SwiftHtml

struct BlogCategoryPageTemplate: TemplateRepresentable {
    
    unowned var req: Request
    var context: BlogCategoryPageContext
    
    init(_ req: Request, context: BlogCategoryPageContext) {
        self.req = req
        self.context = context
    }
    
    @TagBuilder
    var tag: Tag {
        WebIndexTemplate.init(req, context: .init(title: context.category.title)) {
            Div {
                Header {
                    if let imageKey = context.category.imageKey {
                        Img(src: req.fs.resolve(key: imageKey), alt: context.category.title)
                    }
                    H1(context.category.title)
                    P(context.category.excerpt ?? "")
                }
                .class("lead")

                Section {
                    for post in context.category.posts {
                        A {
                            Div {
                                if let imageKey = post.imageKey {
                                    Img(src: req.fs.resolve(key: imageKey), alt: post.title)
                                }
                                H2(post.title)
                                P(post.excerpt ?? "")
                            }
                            .class("content")
                        }
                        .href(post.metadata.slug)
                        .class("card")
                    }
                }
            }
            .id("blog-categories")
            .class("container")
        }.tag
    }
}

