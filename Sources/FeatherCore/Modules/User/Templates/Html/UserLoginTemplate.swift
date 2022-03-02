//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 23..
//

import SwiftHtml

struct UserLoginTemplate: TemplateRepresentable {

    
    var context: UserLoginContext
    var form: TemplateRepresentable
    
    init(_ context: UserLoginContext, form: TemplateRepresentable) {
        self.context = context
        self.form = form
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        WebIndexTemplate(context.index) {
            Wrapper {
                Container {
                    LeadTemplate(.init(title: "Sign in",
                                       excerpt: "Please enter your user credentials to sign in.")).render(req)

                    form.render(req)
                }
            }
        }
        .render(req)
    }
}


