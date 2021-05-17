//
//  IdentifiableController.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

public protocol IdentifiableController: ModelController {
    
    func identifier(_ req: Request) throws -> UUID
    
    /// find a model by identifier if not found return with a notFound error
    func findBy(_ id: UUID, on: Database) -> EventLoopFuture<Model>
}

public extension IdentifiableController {


    func findBy(_ id: UUID, on db: Database) -> EventLoopFuture<Model> {
        Model.find(id, on: db).unwrap(or: Abort(.notFound))
    }

    func identifier(_ req: Request) throws -> UUID {
        guard let id = Model.getIdParameter(req: req) else {
            throw Abort(.badRequest)
        }
        return id
    }
}


public extension IdentifiableController where Model: MetadataRepresentable {

    func findBy(_ id: UUID, on db: Database) -> EventLoopFuture<Model> {
        Model.query(on: db)
            .joinMetadata()
            .filter(\._$id == id).first()
            .unwrap(or: Abort(.notFound))
    }
}
