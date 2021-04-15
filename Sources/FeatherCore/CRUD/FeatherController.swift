//
//  AdminViewController.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

public protocol FeatherController:
    ListViewController,
    GetViewController,
    CreateViewController,
    UpdateViewController,
    DeleteViewController
{}

public protocol FeatherApiRepresentable:
    ListApiRepresentable,
    GetApiRepresentable,
    CreateApiRepresentable,
    UpdateApiRepresentable,
    PatchApiRepresentable,
    DeleteApiRepresentable
{}

/*
 Routes & controller methods:
 ----------------------------------------
 GET /[model]/              listView
 GET /[model]/:id           getView
 GET /[model]/create        createView
    + POST                  create
 GET /[model]/:id/update    updateView
    + POST                  update
 GET /[model]/:id/delete    deleteView
    + POST                  delete
 */
fileprivate extension FeatherController {

    
    func setupRoutes(on builder: RoutesBuilder,
                     createPath: PathComponent = "create",
                     updatePath: PathComponent = "update",
                     deletePath: PathComponent = "delete")
    {
        let base = builder.grouped(Model.Module.pathComponent).grouped(Model.pathComponent)
        setupListRoute(on: base)
        setupGetRoute(on: base)
        setupCreateRoutes(on: base, as: createPath)
        setupUpdateRoutes(on: base, as: updatePath)
        setupDeleteRoutes(on: base, as: deletePath)
    }
    
    func setupApiRoutes(on builder: RoutesBuilder,
                        createPath: PathComponent = "create",
                        updatePath: PathComponent = "update",
                        deletePath: PathComponent = "delete")
    {
        let base = builder.grouped(Model.Module.pathComponent).grouped(Model.pathComponent)
        setupListApiRoute(on: base)
        setupGetApiRoute(on: base)
//        setupCreateRoutes(on: base, as: createPath)
//        setupUpdateRoutes(on: base, as: updatePath)
//        setupDeleteRoutes(on: base, as: deletePath)
    }
}

public extension RoutesBuilder {

    func register<T: FeatherController>(_ controller: T) {
        controller.setupRoutes(on: self)
    }

    func registerApi<T: FeatherController>(_ controller: T) {
        controller.setupApiRoutes(on: self)
    }
}




