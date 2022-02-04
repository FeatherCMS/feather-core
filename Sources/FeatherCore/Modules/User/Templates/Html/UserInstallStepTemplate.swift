//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 25..
//

import SwiftHtml

struct UserInstallStepTemplate: TemplateRepresentable {
    
    var context: UserInstallStepContext
    
    init(_ context: UserInstallStepContext) {
        self.context = context
    }
    
    @TagBuilder
    func render(_ req: Request) -> Tag {
        SystemIndexTemplate(.init(title: "Create root user")) {
            Div {
                Div {
                    LeadTemplate(.init(title: "Create root user",
                                   excerpt: "Configure your root user account")).render(req)
                
                    FormTemplate(context.form).render(req)
                }
                .class("container")
            }
            .class("wrapper")
        }
        .render(req)
    }
}
