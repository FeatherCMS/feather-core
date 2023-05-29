//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor
import SwiftHtml
import SwiftSvg

public struct FileFieldTemplate: TemplateRepresentable {

    public var context: FileFieldContext
    
    public init(_ context: FileFieldContext) {
        self.context = context
    }
    
    
    
    @TagBuilder
    public func render(_ req: Request) -> Tag {
        
        LabelTemplate(context.label).render(req)

        if let url = context.previewKey {
            Div {
                Svg.file
                    .style("padding: 0.5rem; position: absolute; top: 0; left: 0;")
                Svg.download
                    .style("padding: 0.5rem; position: absolute; top: 0; right: 0; color: var(--bg-color-2)")

                A(url)
                    .href(url.resolve(req))
                    .style("font-size: 0.625rem; padding: 0.625rem; margin-left: 1.25rem;")
            }
            .style("border: 1px solid var(--bg-color-2); background: var(--bg-color); border-radius: 0.5rem; padding: 0.25rem; position: relative; margin-top: 0.5rem; margin-bottom: 0.5rem;")
        }
        
        Input()
            .type(.file)
            .key(context.key)
            .class("field")
            .accept(context.accept)
        
        if let temporaryFile = context.data.temporaryFile {
            Input()
                .key(context.key + "TemporaryFileKey")
                .value(temporaryFile.key)
                .type(.hidden)
            
            Input()
                .key(context.key + "TemporaryFileName")
                .value(temporaryFile.name)
                .type(.hidden)
        }
        
        if let key = context.data.originalKey {
            Input()
                .key(context.key + "OriginalKey")
                .value(key)
                .type(.hidden)
        }

        if !context.label.required {
            Input()
                .key(context.key + "ShouldRemove")
                .value(String(true))
                .type(.checkbox)
                .checked(context.data.shouldRemove)

            Label("Remove")
                .for(context.key + "Remove")
        }
        
        if let error = context.error {
            Span(error)
                .class("error")
        }
    }
}
