//
//  File.m
//  
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

/// a protocol on top of the admin view controller, where the associated model is a viper model
public protocol ViperAdminViewController: AdminViewController where Model: ViperModel {
    
    /// we need to associate a generic module type
    associatedtype Module: ViperModule
}

public extension ViperAdminViewController {

    /// default location for the list view templates
    var listView: String { "\(Module.name.capitalized)/Admin/\(Model.name.capitalized)/List" }
    /// default location for the edit view templates
    var editView: String { "\(Module.name.capitalized)/Admin/\(Model.name.capitalized)/Edit" }
    
    /// after we create a new viper model we can redirect the user to the edit screen using the unique id and replace the last path component
    func afterCreate(req: Request, form: EditForm, model: Model) -> EventLoopFuture<Response> {
        req.eventLoop.makeSucceededFuture(req.redirect(to: req.url.path.replaceLastPath(model.viewIdentifier)))
    }
}

public extension ViperAdminViewController {

    func findMetadata(on db: Database, uuid: UUID) -> EventLoopFuture<Metadata?> {
        Metadata.query(on: db)
            .filter(\.$module == Module.name)
            .filter(\.$model == Model.name)
            .filter(\.$reference == uuid)
            .first()
    }
}
