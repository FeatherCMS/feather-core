//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 25..
//

import SwiftHtml

struct MainContext {
    var body: Tag
}

struct MainTemplate: TemplateRepresentable {
    
    let context: MainContext
    
    init(_ context: MainContext) {
        self.context = context
    }
    
    func render(_ req: Request) -> Tag {
        Main {
            Div {
                Div {
                    context.body
                }
                .class("wrapper")
            }
            .class("safe-area")
        }
    }
}
