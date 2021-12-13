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
    /// NOTE: throws instead of bool
    func validate(req: Request) async -> Bool
    func write(req: Request) async
    func save(req: Request) async
    func read(req: Request) async

    func render(req: Request) -> TemplateRepresentable
}
