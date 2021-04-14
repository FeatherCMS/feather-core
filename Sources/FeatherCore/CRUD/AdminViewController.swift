//
//  AdminViewController.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

public protocol AdminViewController:
    ListViewController,
    GetViewController,
    CreateViewController,
    UpdateViewController,
    DeleteViewController
{
    func setupRoutes(on: RoutesBuilder, as: PathComponent, createPath: PathComponent, updatePath: PathComponent, deletePath: PathComponent)
}

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
public extension AdminViewController {

    var listView: String { "System/Admin/List" }
    var getView: String { "System/Admin/Detail" }
    var createView: String { "System/Admin/Edit" }
    var updateView: String { "System/Admin/Edit" }
    var deleteView: String { "System/Admin/Delete" }

    /// after we create a new viper model we can redirect the user to the edit screen using the unique id and replace the last path component
    func createResponse(req: Request, form: CreateForm, model: Model) -> EventLoopFuture<Response> {
        let path = req.url.path.replacingLastPath(model.id!.uuidString)
        return req.eventLoop.future(req.redirect(to: path + "/update/"))
    }

    /// after we delete a model, we can redirect back to the list, using the current path component, but trimming the final uuid/delete part.
    func deleteResponse(req: Request, model: Model) -> EventLoopFuture<Response> {
        // /[model]/:id/delete -> /[model]/
        var url = req.url.path.trimmingLastPathComponents(2)
        if let redirect = try? req.content.get(String.self, at: "redirect") {
            url = redirect
        }
        return req.eventLoop.future(req.redirect(to: url))
    }

    private func viperAccess(_ key: String, req: Request) -> EventLoopFuture<Bool> {
        let permission = Permission(namespace: Model.Module.name, context: Model.name, action: .custom(key))
        return req.checkAccess(for: permission)
    }

    func accessList(req: Request) -> EventLoopFuture<Bool> { viperAccess("list", req: req) }
    func accessGet(req: Request) -> EventLoopFuture<Bool> { viperAccess("get", req: req) }
    func accessCreate(req: Request) -> EventLoopFuture<Bool> { viperAccess("create", req: req) }
    func accessUpdate(req: Request) -> EventLoopFuture<Bool> { viperAccess("update", req: req) }
    func accessDelete(req: Request) -> EventLoopFuture<Bool> { viperAccess("delete", req: req) }
    
    func setupRoutes(on builder: RoutesBuilder,
                     as pathComponent: PathComponent,
                     createPath: PathComponent = "create",
                     updatePath: PathComponent = "update",
                     deletePath: PathComponent = "delete")
    {
        let base = builder.grouped(pathComponent)
        setupListRoute(on: base)
        setupGetRoute(on: base)
        setupCreateRoutes(on: base, as: createPath)
        setupUpdateRoutes(on: base, as: updatePath)
        setupDeleteRoutes(on: base, as: deletePath)
    }
}




