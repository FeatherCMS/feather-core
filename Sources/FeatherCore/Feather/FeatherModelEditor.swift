//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 29..
//

import Vapor
import Fluent
import SwiftHtml

public protocol FeatherModelEditor: FormComponent {
    associatedtype Model: FeatherModel
    
    var model: Model { get }
    var form: FeatherForm { get }
    
    init(model: Model, form: FeatherForm)
        
    @FormComponentBuilder
    var formFields: [FormComponent] { get }
}

public extension FeatherModelEditor {

    func load(req: Request) async throws {
        try await form.load(req: req)
    }
    
    func process(req: Request) async throws {
        try await form.process(req: req)
    }
    /// NOTE: throws instead of bool
    func validate(req: Request) async throws -> Bool {
        try await form.validate(req: req)
    }
    
    func write(req: Request) async throws {
        try await form.write(req: req)
    }
    
    func save(req: Request) async throws {
        try await form.save(req: req)
    }
    
    func read(req: Request) async throws {
        try await form.read(req: req)
    }

    func render(req: Request) -> TemplateRepresentable {
        form.render(req: req)
    }
}

