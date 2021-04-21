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
{
    
    func setupRoutes(on builder: RoutesBuilder)
    func setupApiRoutes(on builder: RoutesBuilder)
}

public protocol FeatherApiRepresentable:
    ListApiRepresentable,
    GetApiRepresentable,
    CreateApiRepresentable,
    UpdateApiRepresentable,
    PatchApiRepresentable,
    DeleteApiRepresentable
{
    
}


public extension FeatherController {

    /*
     Routes & associated controller methods:
     --------------------------------------------------
     GET /[module]/[model]/              listView
     GET /[module]/[model]/:id           getView
     GET /[module]/[model]/create        createView
        + POST                           create
     GET /[module]/[model]/:id/update    updateView
        + POST                           update
     GET /[module]/[model]/:id/delete    deleteView
        + POST                           delete
     */
    func setupRoutes(on builder: RoutesBuilder) {
        let base = builder.grouped(Model.Module.moduleKeyPathComponent).grouped(Model.modelKeyPathComponent)
        setupListRoute(on: base)
        setupGetRoute(on: base)
        setupCreateRoutes(on: base, as: Model.createPathComponent)
        setupUpdateRoutes(on: base, as: Model.updatePathComponent)
        setupDeleteRoutes(on: base, as: Model.deletePathComponent)
    }
    
    /*
     Routes & associated controller methods:
     --------------------------------------------------
     GET    /[module]/[model]/          listApi
     GET    /[module]/[model]/:id       getApi
     POST   /[module]/[model]/:id       createApi
     PUT    /[module]/[model]/:id       updateApi
     PATCH  /[module]/[model]/:id       patchApi
     DELETE /[module]/[model]/:id       deleteApi
     */
    func setupApiRoutes(on builder: RoutesBuilder) {
        let base = builder.grouped(Model.Module.moduleKeyPathComponent).grouped(Model.modelKeyPathComponent)
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

