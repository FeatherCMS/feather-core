//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 17..
//

import Vapor
import SwiftHtml

public struct SeparatorFieldTemplate: TemplateRepresentable {

    public init() {
        
    }

    @TagBuilder
    public func render(_ req: Request) -> Tag {
        Hr()
    }
}
