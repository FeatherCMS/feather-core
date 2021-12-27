//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 26..
//

public protocol FormComponent {
    
    func load(req: Request) async throws
    func process(req: Request) async throws
    /// we're not using a throwing function because we'd like to set error on the form.error property
    func validate(req: Request) async throws -> Bool
    func write(req: Request) async throws
    func save(req: Request) async throws
    func read(req: Request) async throws

    func render(req: Request) -> TemplateRepresentable
}
