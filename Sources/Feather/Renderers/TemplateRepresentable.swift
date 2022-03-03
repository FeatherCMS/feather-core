//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 20..
//

import SwiftHtml

public protocol TemplateRepresentable {
    
    func render(_ req: Request) -> Tag
}
