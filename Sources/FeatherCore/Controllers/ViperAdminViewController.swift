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

    /// default location for the list view templates
    var listView: String { "\(Module.name.capitalized)/Admin/\(Model.name.capitalized)/List" }
    /// default location for the edit view templates
    var editView: String { "\(Module.name.capitalized)/Admin/\(Model.name.capitalized)/Edit" }
    /// default location for the delete view templates
    var deleteView: String { "\(Module.name.capitalized)/Admin/\(Model.name.capitalized)/Delete" }

    /// after we create a new viper model we can redirect the user to the edit screen using the unique id and replace the last path component
    func afterCreate(req: Request, form: EditForm, model: Model) -> EventLoopFuture<Response> {
        req.eventLoop.future(req.redirect(to: req.url.path.replacingLastPath(model.id!.uuidString)))
    }

    /// after we delete a model, we can redirect back to the list, using the current path component, but trimming the final uuid/delete part.
    func afterDelete(req: Request, model: Model) -> EventLoopFuture<Response> {
        req.eventLoop.future(req.redirect(to: req.url.path.trimmingLastPathComponents(2)))
    }
}

public extension ViperAdminViewController {

    /// tries to find a metadata object reference for the given UUID
    func findMetadata(on db: Database, uuid: UUID) -> EventLoopFuture<FrontendMetadata?> {
        FrontendMetadata.query(on: db)
            .filter(\.$module == Module.name)
            .filter(\.$model == Model.name)
            .filter(\.$reference == uuid)
            .first()
    }
}
