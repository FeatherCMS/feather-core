//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 23..
//

import Vapor
import SwiftHtml

struct UserLoginTemplate: TemplateRepresentable {
    
    struct Context {
        var index: WebIndexTemplate.Context
        
        var title: String
        var message: String
        
        init(_ title: String, message: String) {
            self.title = title
            self.message = message
            self.index = .init(title: title)
        }
    }

    unowned var req: Request
    var context: Context
    var form: TemplateRepresentable
    
    init(_ req: Request, context: Context, form: TemplateRepresentable) {
        self.req = req
        self.context = context
        self.form = form
    }

    var tag: Tag {
        WebIndexTemplate(req, context: context.index) {
            Div {
                Div {
                    H1("Sign in")
                    P("Please enter your user credentials to sign in.")
                }
                .class("lead")

                form.tag
            }
            .class("container")
        }.tag
    }
}


