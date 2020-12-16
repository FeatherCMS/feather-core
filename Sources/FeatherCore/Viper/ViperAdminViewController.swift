//
//  ViperAdminViewController.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

/// a protocol on top of the admin view controller, where the associated model is a viper model
public protocol ViperAdminViewController: AdminViewController where Model: ViperModel {
    
    /// we need to associate a generic module type
    associatedtype Module: ViperModule
}

public extension ViperAdminViewController where  Model.IDValue == UUID  {

    var listView: String { "\(Module.name.capitalized)/Admin/\(Model.name.capitalized)/List" }
    var getView: String { "\(Module.name.capitalized)/Admin/\(Model.name.capitalized)/View" }
    var createView: String { "\(Module.name.capitalized)/Admin/\(Model.name.capitalized)/Edit" }
    var updateView: String { "\(Module.name.capitalized)/Admin/\(Model.name.capitalized)/Edit" }
    var deleteView: String { "\(Module.name.capitalized)/Admin/\(Model.name.capitalized)/Delete" }

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
        let name = [Module.name, Model.name, key].joined(separator: ".").replacingOccurrences(of: "_", with: ".")
        return req.checkUserAccess(name)
    }

    func accessList(req: Request) -> EventLoopFuture<Bool> { viperAccess("list", req: req) }
    func accessGet(req: Request) -> EventLoopFuture<Bool> { viperAccess("get", req: req) }
    func accessCreate(req: Request) -> EventLoopFuture<Bool> { viperAccess("create", req: req) }
    func accessUpdate(req: Request) -> EventLoopFuture<Bool> { viperAccess("update", req: req) }
    func accessDelete(req: Request) -> EventLoopFuture<Bool> { viperAccess("delete", req: req) }
}
