//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor

public protocol ApiListController: ListController {
    associatedtype ListObject: Content
    
    func listOutput(_ req: Request, _ models: [DatabaseModel]) async throws -> [ListObject]
    func listApi(_ req: Request) async throws -> ListContainer<ListObject>
    func setUpListRoutes(_ routes: RoutesBuilder)
}

public extension ApiListController {
    
    func listApi(_ req: Request) async throws -> ListContainer<ListObject> {
        let hasAccess = try await listAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let list = try await list(req)
        let apiItems = try await listOutput(req, list.items)
        return ListContainer<ListObject>(apiItems, info: list.info)
    }
    
    func setUpListRoutes(_ routes: RoutesBuilder) {
        let baseRoutes = getBaseRoutes(routes)
        baseRoutes.get(use: listApi)
    }
}
