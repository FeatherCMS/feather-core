//
//  AdminViewController.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

public protocol FeatherController:
    ListController,
    GetController,
    CreateController,
    UpdateController,
    PatchController,
    DeleteController
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

    
    func setupRoutes(on builder: RoutesBuilder) {
        let base = builder.grouped(Model.Module.pathComponent).grouped(Model.pathComponent)
        setupListRoute(on: base)
        setupGetRoute(on: base)
        setupCreateRoutes(on: base, as: Model.createPathComponent)
        setupUpdateRoutes(on: base, as: Model.updatePathComponent)
        setupDeleteRoutes(on: base, as: Model.deletePathComponent)
    }
    
    func setupApiRoutes(on builder: RoutesBuilder) {
        let base = builder.grouped(Model.Module.pathComponent).grouped(Model.pathComponent)
        setupListApiRoute(on: base)
        setupGetApiRoute(on: base)
        setupCreateApiRoute(on: base)
        setupUpdateApiRoute(on: base)
        setupPatchApiRoute(on: base)
        setupDeleteApiRoute(on: base)
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




