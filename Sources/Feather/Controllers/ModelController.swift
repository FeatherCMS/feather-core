//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

public protocol ModelController: Controller {
    associatedtype ApiModel: FeatherApiModel
    associatedtype DatabaseModel: FeatherDatabaseModel
    
    static var moduleName: String { get }
    static var modelName: FeatherModelName { get }
    
    func identifier(_ req: Request) throws -> UUID
    
    func findBy(_ id: UUID, _ req: Request) async throws -> DatabaseModel
    
    func getBaseRoutes(_ routes: RoutesBuilder) -> RoutesBuilder
}

public extension ModelController {

    static var moduleName: String { DatabaseModel.Module.uniqueKey.lowercased().capitalized }
    static var modelName: FeatherModelName { .init(stringLiteral: String(DatabaseModel.uniqueKey.dropLast(1))) }
    
    func getBaseRoutes(_ routes: RoutesBuilder) -> RoutesBuilder {
        routes.grouped(ApiModel.Module.pathKey.pathComponent)
            .grouped(ApiModel.pathKey.pathComponent)
    }
    
    func identifier(_ req: Request) throws -> UUID {
        guard let id = ApiModel.getIdParameter(req) else {
            throw Abort(.badRequest)
        }
        return id
    }

    func findBy(_ id: UUID, _ req: Request) async throws -> DatabaseModel {
        guard let model = try await DatabaseModel.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        return model
    }
}

public extension ModelController where DatabaseModel: MetadataRepresentable {

    func findBy(_ id: UUID, _ req: Request) async throws -> DatabaseModel {
        guard let model = try await DatabaseModel.query(on: req.db).joinMetadata().filter(\._$id == id).first() else {
            throw Abort(.notFound)
        }
        return model
    }
}
