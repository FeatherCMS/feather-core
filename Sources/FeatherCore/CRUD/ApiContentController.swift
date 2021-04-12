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
}
