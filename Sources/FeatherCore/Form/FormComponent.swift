//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 26..
//

import Vapor

public protocol FormComponent {
    
    func load(req: Request) async
    func process(req: Request) async
    /// we're not using a throwing function because we'd like to set error on the form.error property
    func validate(req: Request) async -> Bool
    func write(req: Request) async
    func save(req: Request) async
    func read(req: Request) async

    func render(req: Request) -> TemplateRepresentable
}
