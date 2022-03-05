//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 22..
//

import Vapor
import SwiftHtml

struct SystemFileCreateDirectoryTemplate: TemplateRepresentable {
    
    var context: SystemFileCreateDirectoryContext
    
    init(_ context: SystemFileCreateDirectoryContext) {
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
        SystemIndexTemplate(.init(title: "Create directory")) {//, breadcrumbs: [
//            LinkContext(label: "System", dropLast: 2),
//            LinkContext(label: "Files", dropLast: 1),
//        ])) {
            Wrapper {
                Container {
                    LeadTemplate(.init(title: "Create directory")).render(req)
                    FormTemplate(context.form).render(req)
                }
            }
        }
        .render(req)
    }
}


