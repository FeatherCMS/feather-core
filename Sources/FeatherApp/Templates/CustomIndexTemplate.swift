//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 24..
//

import Vapor
import Feather
import SwiftHtml

final class CustomIndexTemplate: AbstractTemplate<SystemIndexContext> {
    var body: Tag

    init(_ context: SystemIndexContext, @TagBuilder _ builder: () -> Tag) {
        self.body = builder()
        super.init(context)
    }
    
    @TagBuilder
    override func render(_ req: Request) -> Tag {
        Html {
            Head {
                Title("Custom template test")
            }
            Body {
                P("Custom template test")
                
                body
            }
        }
        .lang(context.lang)
    }
}
