//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

public protocol ApiController: ApiListController,
                               ApiDetailController,
                               ApiCreateController,
                               ApiUpdateController,
                               ApiPatchController,
                               ApiDeleteController
{
    func setupRoutes(_ routes: RoutesBuilder)
    func setupPublicRoutes(_ routes: RoutesBuilder)
    
    func validators(optional: Bool) -> [AsyncValidator]
}

public extension ApiController {
    
    func validators(optional: Bool) -> [AsyncValidator] {
        []
    }
    
    func createValidators() -> [AsyncValidator] {
        validators(optional: false)
    }
    
    func updateValidators() -> [AsyncValidator] {
        validators(optional: false)
    }
    
    func patchValidators() -> [AsyncValidator] {
        validators(optional: true)
    }

    func createResponse(_ req: Request, _ model: DatabaseModel) async throws -> Response {
        try await detailOutput(req, model).encodeResponse(status: .created, for: req)
    }
    
    func updateResponse(_ req: Request, _ model: DatabaseModel) async throws -> Response {
        try await detailOutput(req, model).encodeResponse(for: req)
    }

    func patchResponse(_ req: Request, _ model: DatabaseModel) async throws -> Response {
        try await detailOutput(req, model).encodeResponse(for: req)
    }
    

    func setupRoutes(_ routes: RoutesBuilder) {
        setupListRoutes(routes)
        setupDetailRoutes(routes)
        setupCreateRoutes(routes)
        setupUpdateRoutes(routes)
        setupPatchRoutes(routes)
        setupDeleteRoutes(routes)
    }
    
    func setupPublicRoutes(_ routes: RoutesBuilder) {
        // do not expose anything by default
    }
}
