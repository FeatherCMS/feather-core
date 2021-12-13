//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

import Vapor
import Fluent

public protocol ModelController: Controller {
    associatedtype Model: FeatherModel
    
    func identifier(_ req: Request) throws -> UUID
    
    func findBy(_ id: UUID, on: Database) async throws -> Model
}

public extension ModelController {

    func identifier(_ req: Request) throws -> UUID {
        guard let id = Model.getIdParameter(req: req) else {
            throw Abort(.badRequest)
        }
        return id
    }

    func findBy(_ id: UUID, on db: Database) async throws -> Model {
        guard let model = try await Model.find(id, on: db) else {
            throw Abort(.notFound)
        }
        return model
    }
}
