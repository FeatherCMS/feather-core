//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

public protocol ApiCreateController: CreateController {
    associatedtype CreateObject: Decodable

    func createValidators() -> [AsyncValidator]
    func createInput(_ req: Request, _ model: DatabaseModel, _ input: CreateObject) async throws
    func createApi(_ req: Request) async throws -> Response
    func createResponse(_ req: Request, _ model: DatabaseModel) async throws -> Response
    func setUpCreateRoutes(_ routes: RoutesBuilder)
}

public extension ApiCreateController {

    func createValidators() -> [AsyncValidator] {
        []
    }
    
    func createApi(_ req: Request) async throws -> Response {
        let hasAccess = try await createAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        try await RequestValidator(createValidators()).validate(req)
        let input = try req.content.decode(CreateObject.self)
        let model = DatabaseModel()
        try await createInput(req, model, input)
        try await beforeCreate(req, model)
        try await model.create(on: req.db)
        try await afterCreate(req, model)
        return try await createResponse(req, model)
    }
    
    func setUpCreateRoutes(_ routes: RoutesBuilder) {
        let baseRoutes = getBaseRoutes(routes)
        baseRoutes.post(use: createApi)
    }
    
}
