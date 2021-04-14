//
//  ApiController.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

public protocol ApiContentController:
    ListContentController,
    GetContentController,
    CreateContentController,
    UpdateContentController,
    PatchContentController,
    DeleteContentController
{
    func setupRoutes(on: RoutesBuilder, as: PathComponent)
}

public extension ApiContentController {

    func setupRoutes(on builder: RoutesBuilder, as pathComponent: PathComponent) {
        let modelRoutes = builder.grouped(pathComponent)
        setupListRoute(on: modelRoutes)
        setupGetRoute(on: modelRoutes)
        setupCreateRoute(on: modelRoutes)
        setupUpdateRoute(on: modelRoutes)
        setupPatchRoute(on: modelRoutes)
        setupDeleteRoute(on: modelRoutes)
    }
    
    private func viperAccess(_ key: String, req: Request) -> EventLoopFuture<Bool> {
        let permission = Permission(namespace: Model.Module.name, context: Model.name, action: .custom(key))
        return req.checkAccess(for: permission)
    }

    func accessList(req: Request) -> EventLoopFuture<Bool> { viperAccess("list", req: req) }
    func accessGet(req: Request) -> EventLoopFuture<Bool> { viperAccess("get", req: req) }
    func accessCreate(req: Request) -> EventLoopFuture<Bool> { viperAccess("create", req: req) }
    func accessUpdate(req: Request) -> EventLoopFuture<Bool> { viperAccess("update", req: req) }
    func accessPatch(req: Request) -> EventLoopFuture<Bool> { viperAccess("update", req: req) }
    func accessDelete(req: Request) -> EventLoopFuture<Bool> { viperAccess("delete", req: req) }
}
