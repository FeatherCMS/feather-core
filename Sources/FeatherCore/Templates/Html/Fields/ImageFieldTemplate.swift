//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor
import SwiftHtml

public struct ImageFieldTemplate: TemplateRepresentable {

    public var context: ImageFieldContext
    
    public init(_ context: ImageFieldContext) {
        self.context = context
    }
    
    @TagBuilder
    public var tag: Tag {
        
        if let url = context.previewUrl {
            Img(src: url, alt: context.key)
        }
//        else {
//            if let placeholder = context.placeholderIcon {
//                Svg()
//            }
//        }
        
        LabelTemplate(context.label).tag
        
        Input()
            .type(.file)
            .key(context.key)
            .class("field")
            .accept(context.accept)
        
        if let temporaryFile = context.temporaryFile {
            Input()
                .key(context.key + "TemporaryFileKey")
                .value(temporaryFile.key)
                .type(.hidden)
            
            Input()
                .key(context.key + "TemporaryFileName")
                .value(temporaryFile.name)
                .type(.hidden)
        }
        
        if let key = context.originalKey {
            Input()
                .key(context.key + "OriginalKey")
                .value(key)
                .type(.hidden)
        }

        if !context.label.required {
            Input()
                .key(context.key + "Remove")
                .value(String(true))
                .type(.checkbox)
                .checked(context.remove)

            Label("Remove")
                .for(context.key + "Remove")
        }
        
        if let error = context.error {
            Span(error)
                .class("error")
        }
    }
}
