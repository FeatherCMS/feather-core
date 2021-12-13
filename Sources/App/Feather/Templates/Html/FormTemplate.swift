//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 26..
//

import Vapor
import SwiftHtml

public struct FormTemplate: TemplateRepresentable {
    
    unowned var req: Request
    var context: FormContext
    
    public init(_ req: Request, _ context: FormContext) {
        self.req = req
        self.context = context
    }

    public var tag: Tag {
        Form {
            if let error = context.error {
                Section {
                    P(error)
                        .class("error")
                }
            }
            
            Input()
                .type(.hidden)
                .name("formId")
                .value(context.id)
            Input()
                .type(.hidden)
                .name("formToken")
                .value(context.token)
            
            context.fields.map { field in
                Section {
                    field.tag
                }
            }
            Section {
                Input()
                    .type(.submit)
                    .value(context.submit ?? "Save")
            }
        }
        .method(context.action.method)
        .action(context.action.url)
        .enctype(context.action.enctype)
    }
}


