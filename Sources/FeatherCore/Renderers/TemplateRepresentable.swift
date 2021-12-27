//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 20..
//

import SwiftHtml

public protocol TemplateRepresentable {
    
    @TagBuilder
    func render(_ req: Request) -> Tag
}
