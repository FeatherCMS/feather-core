//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//

import Foundation
import SwiftHtml

public struct DetailTemplate: TemplateRepresentable {
    
    var context: DetailContext

    public init(_ context: DetailContext) {
        self.context = context
    }

    @TagBuilder
    public func render(_ req: Request) -> Tag {
        Dt(context.label)
        switch context.type {
        case .text:
            if let value = context.value, !value.isEmpty {
                Dd(value.replacingOccurrences(of: "\n", with: "<br>"))
            }
            else {
                Dd("-")
            }
        case .image:
            Dd {
                if let value = context.value, !value.isEmpty {
                    Img(src: req.fs.resolve(key: value), alt: context.label)
                }
                else {
                    Text("-")
                }
            }
        }
    }
}


