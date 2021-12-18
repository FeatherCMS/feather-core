//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 29..
//

import Foundation
import Vapor

public protocol AdminController: FeatherController {

    // MARK: - names

    static var moduleName: String { get }
    static var modelName: FeatherModelName { get }
    
    // MARK: - path components
    
    static var createPathComponent: PathComponent { get }
    static var updatePathComponent: PathComponent { get }
    static var deletePathComponent: PathComponent { get }
    static var rowIdPathComponent: PathComponent { get }
    
    static var modulePathComponents: [PathComponent] { get }
    static var modulePath: String { get }
    static var listPathComponents: [PathComponent] { get }
    static var listPath: String { get }
    static var createPathComponents: [PathComponent] { get }
    static var createPath: String { get }
    static func detailPathComponents(for id: UUID) -> [PathComponent]
    static func detailPath(for id: UUID) -> String
    static func updatePathComponents(for id: UUID) -> [PathComponent]
    static func updatePath(for id: UUID) -> String
    static func deletePathComponents(for id: UUID) -> [PathComponent]
    static func deletePath(for id: UUID) -> String
    static var rowIdPathComponents: [PathComponent] { get }
    static var rowIdPath: String { get }
    static var rowUpdatePathComponents: [PathComponent] { get }
    static var rowUpdatePath: String { get }
    static var rowDeletePathComponents: [PathComponent] { get }
    static var rowDeletePath: String { get }
    
    static func moduleLink(_ label: String) -> LinkContext
    static func listLink(_ label: String) -> LinkContext
    static func createLink(_ label: String) -> LinkContext
    static func detailLink(_ label: String, id: UUID) -> LinkContext
    static func updateLink(_ label: String, id: UUID) -> LinkContext
    static func deleteLink(_ label: String, id: UUID) -> LinkContext
    static func updateTableAction(_ label: String) -> LinkContext
    static func deleteTableAction(_ label: String) -> LinkContext
    
    // MARK: - contexts
    
    func listColumns() -> [ColumnContext]
    func listCells(for model: Model) -> [CellContext]
    func listContext(_ req: Request, _ list: ListContainer<Model>) -> AdminListPageContext
    func listNavigation(_ req: Request) -> [LinkContext]
    func listBreadcrumbs(_ req: Request) -> [LinkContext]

    func detailFields(for model: Model) -> [FieldContext]
    func detailContext(_ req: Request, _ model: Model) -> AdminDetailPageContext
    func detailBreadcrumbs(_ req: Request, _ model: Model) -> [LinkContext]
    func detailLinks(_ req: Request, _ model: Model) -> [LinkContext]

    func createContext(_ req: Request, _ editor: CreateModelEditor) -> AdminEditorPageContext
    func createBreadcrumbs(_ req: Request) -> [LinkContext]
    
    func updateContext(_ req: Request, _ editor: UpdateModelEditor) async -> AdminEditorPageContext
    func updateBreadcrumbs(_ req: Request, _ model: Model) -> [LinkContext]
    func updateLinks(_ req: Request, _ model: Model) -> [LinkContext]

    func deleteInfo(_ model: Model) -> String
    func deleteContext(_ req: Request, _ model: Model, _ form: DeleteForm) -> AdminDeletePageContext
    
    // MARK: - routes
    
    func getBaseRoutes(_ routes: RoutesBuilder) -> RoutesBuilder
    func setupAdminRoutes(_ routes: RoutesBuilder)
    func setupAdminApiRoutes(_ routes: RoutesBuilder)
    func setupPublicApiRoutes(_ routes: RoutesBuilder)
}

public extension AdminController {

    static var createPathComponent: PathComponent { "create" }
    static var updatePathComponent: PathComponent { "update" }
    static var deletePathComponent: PathComponent { "delete" }
    static var rowIdPathComponent: PathComponent { ":rowId" }

    static var modulePathComponents: [PathComponent] {
        [
            Feather.config.paths.admin.pathComponent,
            Model.Module.pathComponent,
        ]
    }
    
    static var modulePath: String {
        modulePathComponents.path
    }

    static var listPathComponents: [PathComponent] {
        modulePathComponents + [Model.pathComponent]
    }
    
    static var listPath: String {
        listPathComponents.path
    }
    
    static var createPathComponents: [PathComponent] {
        listPathComponents + [createPathComponent]
    }
    
    static var createPath: String {
        createPathComponents.path
    }
    
    static func detailPathComponents(for id: UUID) -> [PathComponent] {
        listPathComponents + [.init(stringLiteral: id.string)]
    }
    
    static func detailPath(for id: UUID) -> String {
        detailPathComponents(for: id).path
    }
    
    static func updatePathComponents(for id: UUID) -> [PathComponent] {
        detailPathComponents(for: id) + [updatePathComponent]
    }
    
    static func updatePath(for id: UUID) -> String {
        updatePathComponents(for: id).path
    }
    
    static func deletePathComponents(for id: UUID) -> [PathComponent] {
        detailPathComponents(for: id) + [deletePathComponent]
    }
    
    static func deletePath(for id: UUID) -> String {
        deletePathComponents(for: id).path
    }
    
    static var rowIdPathComponents: [PathComponent] {
        listPathComponents + [rowIdPathComponent]
    }
    
    static var rowIdPath: String {
        rowIdPathComponents.path
    }
    
    static var rowUpdatePathComponents: [PathComponent] {
        rowIdPathComponents + [updatePathComponent]
    }
    
    static var rowUpdatePath: String {
        rowUpdatePathComponents.path
    }
    
    static var rowDeletePathComponents: [PathComponent] {
        rowIdPathComponents + [deletePathComponent]
    }
    
    static var rowDeletePath: String {
        rowDeletePathComponents.path
    }

    static func moduleLink(_ label: String) -> LinkContext {
        .init(label: label, url: modulePath)
    }
    
    static func listLink(_ label: String = "List") -> LinkContext {
        .init(label: label, url: listPath, permission: listPermission())
    }
    
    static func createLink(_ label: String = "Create") -> LinkContext {
        .init(label: label, url: createPath, permission: createPermission())
    }

    static func detailLink(_ label: String = "Details", id: UUID) -> LinkContext {
        .init(label: label, url: detailPath(for: id), permission: detailPermission())
    }
    
    static func updateLink(_ label: String = "Update", id: UUID) -> LinkContext {
        .init(label: label, url: updatePath(for: id), permission: updatePermission())
    }
    
    static func deleteLink(_ label: String = "Delete", id: UUID) -> LinkContext {
        .init(label: label, url: deletePath(for: id), permission: deletePermission(), style: "destructive")
    }
    
    static func updateTableAction(_ label: String = "Update") -> LinkContext {
        .init(label: label, url: rowUpdatePath, permission: updatePermission())
    }

    static func deleteTableAction(_ label: String = "Delete") -> LinkContext {
        .init(label: label, url: rowDeletePath, permission: deletePermission())
    }
}

public extension AdminController {
    
    static var moduleName: String { Model.Module.moduleKey.uppercasedFirst }
    static var modelName: FeatherModelName { Model.modelKey }
    
    func listContext(_ req: Request, _ list: ListContainer<Model>) -> AdminListPageContext {
        let rows = list.items.map {
            RowContext(id: $0.identifier, cells: listCells(for: $0))
        }
        let table = TableContext(id: [Model.Module.moduleKey, Model.modelKey.singular, "table"].joined(separator: "-"),
                                 columns: listColumns(),
                                 rows: rows,
                                 actions: [
                                    Self.updateTableAction(),
                                    Self.deleteTableAction(),
                                 ],
                                 options: .init(allowedOrders: listConfig.allowedOrders.map(\.description),
                                                defaultSort: listConfig.defaultSort))

        return .init(title: Self.modelName.plural.uppercasedFirst,
                     isSearchable: listConfig.isSearchable,
                     table: table,
                     pagination: list.info,
                     navigation: listNavigation(req),
                     breadcrumbs: listBreadcrumbs(req))
    }
    
    func listNavigation(_ req: Request) -> [LinkContext] {
        [
           Self.createLink()
        ]
    }
    
    func listBreadcrumbs(_ req: Request) -> [LinkContext] {
        [
           Self.moduleLink(Self.moduleName.uppercasedFirst),
        ]
    }

    func detailContext(_ req: Request, _ model: Model) -> AdminDetailPageContext {
        .init(title: Self.modelName.singular.uppercasedFirst + " details",
              fields: detailFields(for: model),
              breadcrumbs: detailBreadcrumbs(req, model),
              links: detailLinks(req, model),
              actions: [
                    Self.deleteLink(id: model.uuid),
              ])
    }
    
    func detailBreadcrumbs(_ req: Request, _ model: Model) -> [LinkContext] {
        [
            Self.moduleLink(Self.moduleName.uppercasedFirst),
            Self.listLink(Self.modelName.plural.uppercasedFirst),
        ]
    }

    func detailLinks(_ req: Request, _ model: Model) -> [LinkContext] {
        [
              Self.updateLink(id: model.uuid)
        ]
    }

    func createContext(_ req: Request, _ editor: CreateModelEditor) -> AdminEditorPageContext {
        .init(title: "Create " + Self.modelName.singular,
              form: editor.form.context(req),
              breadcrumbs: createBreadcrumbs(req))
    }
    
    func createBreadcrumbs(_ req: Request) -> [LinkContext] {
        [
              Self.moduleLink(Self.moduleName.uppercasedFirst),
              Self.listLink(Self.modelName.plural.uppercasedFirst),
        ]
    }
    
    func updateContext(_ req: Request, _ editor: UpdateModelEditor) async -> AdminEditorPageContext {
       .init(title: "Update " + Self.modelName.singular,
             form: editor.form.context(req),
             breadcrumbs: updateBreadcrumbs(req, editor.model as! Model),
             links: updateLinks(req, editor.model as! Model),
             actions: [
                Self.deleteLink(id: editor.model.uuid),
             ])
    }
    
    func updateBreadcrumbs(_ req: Request, _ model: Model) -> [LinkContext] {
        [
              Self.moduleLink(Self.moduleName.uppercasedFirst),
              Self.listLink(Self.modelName.plural.uppercasedFirst),
        ]
    }
    
    func updateLinks(_ req: Request, _ model: Model) -> [LinkContext] {
        [
           Self.detailLink(id: model.uuid),
        ]
    }
    
    func deleteContext(_ req: Request, _ model: Model, _ form: DeleteForm) -> AdminDeletePageContext {
        .init(title: "Delete " + Self.modelName.singular,
              name: deleteInfo(model),
              type: Self.modelName.singular,
              form: form.context(req))
    }
}


public extension AdminController {
    
    func listTemplate(_ req: Request, _ list: ListContainer<Model>) -> TemplateRepresentable {
        AdminListPageTemplate(req, listContext(req, list))
    }
    
    func detailTemplate(_ req: Request, _ model: Model) -> TemplateRepresentable {
        AdminDetailPageTemplate(req, detailContext(req, model))
    }
    
    func createTemplate(_ req: Request, _ editor: CreateModelEditor) -> TemplateRepresentable {
        AdminEditorPageTemplate(req, createContext(req, editor))
    }

    func updateTemplate(_ req: Request, _ editor: UpdateModelEditor) async -> TemplateRepresentable {
        await AdminEditorPageTemplate(req, updateContext(req, editor))
    }
    
    func deleteTemplate(_ req: Request, _ model: Model, _ form: DeleteForm) -> TemplateRepresentable {
        AdminDeletePageTemplate(req, deleteContext(req, model, form))
    }
}

public extension AdminController {
    
    func getBaseRoutes(_ routes: RoutesBuilder) -> RoutesBuilder {
        routes.grouped(Model.Module.pathComponent)
            .grouped(Model.pathComponent)
    }

    func setupAdminRoutes(_ routes: RoutesBuilder) {
        let baseRoutes = getBaseRoutes(routes)
        
        baseRoutes.get(use: listView)
        
        baseRoutes.get(Self.createPathComponent, use: createView)
        baseRoutes.post(Self.createPathComponent, use: create)
        
        let existingModelRoutes = baseRoutes.grouped(Model.idPathComponent)
        
        existingModelRoutes.get(use: detailView)
        
        existingModelRoutes.get(Self.updatePathComponent, use: updateView)
        existingModelRoutes.post(Self.updatePathComponent, use: update)
        
        existingModelRoutes.get(Self.deletePathComponent, use: deleteView)
        existingModelRoutes.post(Self.deletePathComponent, use: delete)
    }
    
    func setupAdminApiRoutes(_ routes: RoutesBuilder) {
        let baseRoutes = getBaseRoutes(routes)
        
        baseRoutes.get(use: listApi)
        baseRoutes.post(use: createApi)
        
        let existingModelRoutes = baseRoutes.grouped(Model.idPathComponent)
        existingModelRoutes.get(use: detailApi)
        existingModelRoutes.post(use: updateApi)
        existingModelRoutes.patch(use: patchApi)
        existingModelRoutes.delete(use: deleteApi)
    }
    
    func setupPublicApiRoutes(_ routes: RoutesBuilder) {
        // do not expose anything by default
    }
}
