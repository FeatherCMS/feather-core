//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 12..
//

import Vapor

public protocol FormField: FormEventResponder {
    func render(req: Request) -> TemplateRepresentable
}
