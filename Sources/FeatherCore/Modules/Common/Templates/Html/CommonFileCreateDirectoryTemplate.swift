//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 22..
//

import SwiftHtml

struct CommonFileCreateDirectoryTemplate: TemplateRepresentable {
    
    var context: CommonFileCreateDirectoryContext
    
    init(_ context: CommonFileCreateDirectoryContext) {
        self.context = context
    }

    func currentKey(_ req: Request) -> String {
        if let key = try? req.query.get(String.self, at: "key") {
            return key
        }
        return ""
    }
    
    @TagBuilder
    func render(_ req: Request) -> Tag {
        AdminIndexTemplate(.init(title: "Create directory", breadcrumbs: [
            LinkContext(label: "Common", dropLast: 2),
            LinkContext(label: "Files", dropLast: 1),
        ])) {
            Div {
                Div {
                    H1("Create directory")
                    
                }
                .class("lead")
                
                FormTemplate(context.form).render(req)
            }
        }
        .render(req)
    }
}


