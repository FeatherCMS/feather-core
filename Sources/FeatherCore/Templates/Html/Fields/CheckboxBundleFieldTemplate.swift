//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import SwiftHtml

public struct CheckboxBundleFieldTemplate: TemplateRepresentable {

    var context: CheckboxBundleFieldContext
    
    public init(_ context: CheckboxBundleFieldContext) {
        self.context = context
    }

    @TagBuilder
    public func render(_ req: Request) -> Tag {
        LabelTemplate(context.label).render(req)
        
        if context.options.isEmpty {
            Label {
                Span("No available options")
                    .class("more")
            }
        }
        else {
            for bundle in context.options {
                Fieldset {
                    Legend(bundle.name)
                    
                    Div {
                        for group in bundle.groups {
                            Section {
                                Label(group.name)
                                    .class("block")
                                for option in group.options {
                                    Input()
                                        .type(.checkbox)
                                        .name(context.key + "[]")
                                        .value(option.key)
                                        .id(option.key)
                                        .checked(context.values.contains(option.key))
                                    Label(option.label)
                                        .for(option.key)
                                    Br()
                                }
                            }
                        }
                    }
                }
            }
        }

        if let error = context.error {
            Span(error)
                .class("error")
        }
    }
}
