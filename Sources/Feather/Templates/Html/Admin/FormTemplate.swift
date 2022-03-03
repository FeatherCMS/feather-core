//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 26..
//

import SwiftHtml

public struct FormTemplate: TemplateRepresentable {
    
    var context: FormContext
    
    public init(_ context: FormContext) {
        self.context = context
    }

    public func render(_ req: Request) -> Tag {
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
                Section(field.render(req))
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
