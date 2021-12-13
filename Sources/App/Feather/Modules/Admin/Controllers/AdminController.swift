//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 29..
//

import Foundation
import Vapor

public struct AdminContext {

    public struct ModuleInfo: Encodable {
        public let name: String
        public let key: String
        public let path: String
        
        public init(key: String,
                    name: String,
                    path: String) {
            self.key = key
            self.name = name
            self.path = path
        }
    }

    public struct ModelInfo {
        
        public struct Name {
            public let singular: String
            public let plural: String
            
            public init(singular: String, plural: String) {
                self.singular = singular
                self.plural = plural
            }
        }
        
        public let key: String
        public let name: AdminContext.ModelInfo.Name
        public let path: String
        public let idParamKey: String

        
        internal init(key: String,
                      name: AdminContext.ModelInfo.Name,
                      path: String, idParamKey: String) {
            self.key = key
            self.name = name
            self.path = path
            self.idParamKey = idParamKey
        }
    }

    public let module: ModuleInfo
    public let model: ModelInfo
}

public protocol AdminController: FeatherController {

    var createPathComponent: PathComponent { get }
    var updatePathComponent: PathComponent { get }
    var deletePathComponent: PathComponent { get }
    
    var context: AdminContext { get }
    
    func listContext(_ req: Request, _ list: ListContainer<Model>) -> AdminListPageContext
    func detailContext(_ req: Request, _ model: Model) -> AdminDetailPageContext
    func deleteContext(_ req: Request, _ model: Model, _ form: DeleteForm) -> AdminDeletePageContext
    
    var listLink: LinkContext { get }
    func createLink() -> LinkContext
    func detailLink(for id: UUID) -> LinkContext
    func updateLink(for id: UUID) -> LinkContext
    func deleteLink(for id: UUID) -> LinkContext
    
    func listPermission() -> FeatherPermission
    func detailPermission() -> FeatherPermission
    func createPermission() -> FeatherPermission
    func updatePermission() -> FeatherPermission
    func deletePermission() -> FeatherPermission
    
    func listPermission() -> String
    func detailPermission() -> String
    func createPermission() -> String
    func updatePermission() -> String
    func deletePermission() -> String
    
    func hasListPermission(_ req: Request) -> Bool
    func hasDetailPermission(_ req: Request) -> Bool
    func hasCreatePermission(_ req: Request) -> Bool
    func hasUpdatePermission(_ req: Request) -> Bool
    func hasDeletePermission(_ req: Request) -> Bool
    
    func setupAdminRoutes(_ routes: RoutesBuilder)
    func setupAdminApiRoutes(_ routes: RoutesBuilder)
    func setupPublicApiRoutes(_ routes: RoutesBuilder)
}

public extension AdminController {
    
    var context: AdminContext {
        .init(module: .init(key: Model.Module.moduleKey,
                            name: Model.Module.moduleKey.uppercasedFirst,
                            path: Model.Module.moduleKey),
              model: .init(key: Model.modelKey,
                           name: .init(singular: String(Model.modelKey.dropLast()).uppercasedFirst, plural: String(Model.modelKey.dropLast()).uppercasedFirst + "s"),
                           path: Model.modelKey,
                           idParamKey: Model.idParamKey))
    }
    
    // MARK: - permission helpers
    
    func listPermission() -> FeatherPermission {
        Model.permission(.list)
    }
    
    func detailPermission() -> FeatherPermission {
        Model.permission(.detail)
    }
    
    func createPermission() -> FeatherPermission {
        Model.permission(.create)
    }
    
    func updatePermission() -> FeatherPermission {
        Model.permission(.update)
    }
    
    func deletePermission() -> FeatherPermission {
        Model.permission(.delete)
    }

    func listPermission() -> String {
        listPermission().rawValue
    }
    
    func detailPermission() -> String {
        detailPermission().rawValue
    }
    
    func createPermission() -> String {
        createPermission().rawValue
    }
    
    func updatePermission() -> String {
        updatePermission().rawValue
    }
    
    func deletePermission() -> String {
        deletePermission().rawValue
    }
    
    func hasListPermission(_ req: Request) -> Bool {
        req.checkPermission(listPermission())
    }
    
    func hasDetailPermission(_ req: Request) -> Bool {
        req.checkPermission(detailPermission())
    }
    
    func hasCreatePermission(_ req: Request) -> Bool {
        req.checkPermission(createPermission())
    }
    
    func hasUpdatePermission(_ req: Request) -> Bool {
        req.checkPermission(updatePermission())
    }
    
    func hasDeletePermission(_ req: Request) -> Bool {
        req.checkPermission(deletePermission())
    }

    // MARK: - paths & links
    
    var createPathComponent: PathComponent { "create" }
    var updatePathComponent: PathComponent { "update" }
    var deletePathComponent: PathComponent { "delete" }
    
    private var listComponents: [PathComponent] {
        [
            Feather.config.paths.admin.pathComponent,
            Model.Module.modulePathComponent,
            Model.modelPathComponent
        ]
    }

    var listLink: LinkContext {
        return .init(label: context.model.name.plural,
                     url: listComponents.string.safePath(),
                     permission: Model.permission(.list).rawValue)
    }

    func createLink() -> LinkContext {
        var components = listComponents
        components.append(createPathComponent)
        return .init(label: context.model.name.singular,
                     url: components.string.safePath(),
                     permission: Model.permission(.create).rawValue)
    }
    
    func detailLink(for id: UUID) -> LinkContext {
        var components = listComponents
        components.append(.init(stringLiteral: id.uuidString))
        return .init(label: context.model.name.singular,
                     url: components.string.safePath(),
                     permission: Model.permission(.detail).rawValue)
    }
    
    func updateLink(for id: UUID) -> LinkContext {
        var components = listComponents
        components.append(.init(stringLiteral: id.uuidString))
        components.append(updatePathComponent)
        return .init(label: context.model.name.singular,
                     url: components.string.safePath(),
                     permission: Model.permission(.update).rawValue)
    }
    
    func deleteLink(for id: UUID) -> LinkContext {
        var components = listComponents
        components.append(.init(stringLiteral: id.uuidString))
        components.append(deletePathComponent)
        return .init(label: context.model.name.singular,
                     url: components.string.safePath(),
                     permission: Model.permission(.delete).rawValue)
    }

    // MARK: - templates
    
    func listTemplate(_ req: Request, _ list: ListContainer<Model>) -> TemplateRepresentable {
        AdminListPageTemplate(req, listContext(req, list))
    }
    
    func detailTemplate(_ req: Request, _ model: Model) -> TemplateRepresentable {
        AdminDetailPageTemplate(req, detailContext(req, model))
    }
    
    func createTemplate(_ req: Request, _ editor: CreateModelEditor, _ form: FeatherForm) -> TemplateRepresentable {
        AdminEditorPageTemplate(req, .init(title: "Create", form: form.context(req)))
    }
    
    func updateTemplate(_ req: Request, _ editor: UpdateModelEditor, _ form: FeatherForm) -> TemplateRepresentable {
        AdminEditorPageTemplate(req, .init(title: "Update", form: form.context(req)))
    }
    
    func deleteTemplate(_ req: Request, _ model: Model, _ form: DeleteForm) -> TemplateRepresentable {
        AdminDeletePageTemplate(req, deleteContext(req, model, form))
    }
    
    func setupAdminRoutes(_ routes: RoutesBuilder) {
        let moduleRoutes = routes.grouped(.init(stringLiteral: Model.Module.moduleKey))
        let modelRoutes = moduleRoutes.grouped(.init(stringLiteral: Model.modelKey))
        
        modelRoutes.get(use: listView)
        
        modelRoutes.get(createPathComponent, use: createView)
        modelRoutes.post(createPathComponent, use: create)
        
        let existingModelRoutes = modelRoutes.grouped(Model.idParamKeyPathComponent)
        
        existingModelRoutes.get(use: detailView)
        
        existingModelRoutes.get(updatePathComponent, use: updateView)
        existingModelRoutes.post(updatePathComponent, use: update)
        
        existingModelRoutes.get(deletePathComponent, use: deleteView)
        existingModelRoutes.post(deletePathComponent, use: delete)
    }
    
    func setupAdminApiRoutes(_ routes: RoutesBuilder) {
        let moduleRoutes = routes.grouped(.init(stringLiteral: Model.Module.moduleKey))
        let modelRoutes = moduleRoutes.grouped(.init(stringLiteral: Model.modelKey))
        
        modelRoutes.get(use: listApi)
        modelRoutes.post(use: createApi)
        
        let existingModelRoutes = modelRoutes.grouped(Model.idParamKeyPathComponent)
        existingModelRoutes.get(use: detailApi)
        existingModelRoutes.post(use: updateApi)
        existingModelRoutes.patch(use: patchApi)
        existingModelRoutes.delete(use: deleteApi)
    }
    
    func setupPublicApiRoutes(_ routes: RoutesBuilder) {
        // do not expose anything by default
    }
}
