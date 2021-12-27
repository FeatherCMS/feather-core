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
            Header {
                H1("Create root user")
                P("Configure your root user account")
            }

            FormTemplate(context.form).render(req)
        }
        .render(req)
    }
}
