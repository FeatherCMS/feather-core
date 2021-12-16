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
    static func updateTableAction(_ label: String) -> LinkContext
    static func deleteTableAction(_ label: String) -> LinkContext
    
    // MARK: - permission
    
    static func listPermission() -> FeatherPermission
    static func detailPermission() -> FeatherPermission
    static func createPermission() -> FeatherPermission
    static func updatePermission() -> FeatherPermission
    static func deletePermission() -> FeatherPermission
    
    static func listPermission() -> String
    static func detailPermission() -> String
    static func createPermission() -> String
    static func updatePermission() -> String
    static func deletePermission() -> String
    
    static func hasListPermission(_ req: Request) -> Bool
    static func hasDetailPermission(_ req: Request) -> Bool
    static func hasCreatePermission(_ req: Request) -> Bool
    static func hasUpdatePermission(_ req: Request) -> Bool
    static func hasDeletePermission(_ req: Request) -> Bool
    
    // MARK: -

    var context: AdminContext { get }
    
    func listColumns() -> [ColumnContext]
    func listCells(for model: Model) -> [CellContext]
    func listContext(_ req: Request, _ list: ListContainer<Model>) -> AdminListPageContext
    
    func detailFields(for model: Model) -> [FieldContext]
    func detailContext(_ req: Request, _ model: Model) -> AdminDetailPageContext

    func deleteInfo(_ model: Model) -> String
    func deleteContext(_ req: Request, _ model: Model, _ form: DeleteForm) -> AdminDeletePageContext
    
    // MARK: - templates
    
    func listTemplate(_ req: Request, _ list: ListContainer<Model>) -> TemplateRepresentable
    func detailTemplate(_ req: Request, _ model: Model) -> TemplateRepresentable
    func createTemplate(_ req: Request, _ editor: CreateModelEditor, _ form: FeatherForm) -> TemplateRepresentable
    func updateTemplate(_ req: Request, _ editor: UpdateModelEditor, _ form: FeatherForm) -> TemplateRepresentable
    func deleteTemplate(_ req: Request, _ model: Model, _ form: DeleteForm) -> TemplateRepresentable
    
    // MARK: - routes
    
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
        listPathComponents + [.init(stringLiteral: id.uuidString)]
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
        .init(label: label, url: modulePathComponents.path)
    }
    
    static func listLink(_ label: String = "List") -> LinkContext {
        .init(label: label, url: listPathComponents.path, permission: listPermission())
    }
    
    static func createLink(_ label: String = "Create new") -> LinkContext {
        .init(label: label, url: createPathComponents.path, permission: createPermission())
    }

    static func detailLink(_ label: String = "Details", id: UUID) -> LinkContext {
        .init(label: label, url: detailPathComponents(for: id).path, permission: detailPermission())
    }
    
    static func updateTableAction(_ label: String = "Update") -> LinkContext {
        .init(label: label, url: rowUpdatePathComponents.path, permission: updatePermission())
    }

    static func deleteTableAction(_ label: String = "Delete") -> LinkContext {
        .init(label: label, url: rowDeletePathComponents.path, permission: deletePermission())
    }
}

public extension AdminController {

    static func listPermission() -> FeatherPermission {
        Model.permission(.list)
    }
    
    static func detailPermission() -> FeatherPermission {
        Model.permission(.detail)
    }
    
    static func createPermission() -> FeatherPermission {
        Model.permission(.create)
    }
    
    static func updatePermission() -> FeatherPermission {
        Model.permission(.update)
    }
    
    static func deletePermission() -> FeatherPermission {
        Model.permission(.delete)
    }

    static func listPermission() -> String {
        listPermission().rawValue
    }
    
    static func detailPermission() -> String {
        detailPermission().rawValue
    }
    
    static func createPermission() -> String {
        createPermission().rawValue
    }
    
    static func updatePermission() -> String {
        updatePermission().rawValue
    }
    
    static func deletePermission() -> String {
        deletePermission().rawValue
    }
    
    static func hasListPermission(_ req: Request) -> Bool {
        req.checkPermission(listPermission())
    }
    
    static func hasDetailPermission(_ req: Request) -> Bool {
        req.checkPermission(detailPermission())
    }
    
    static func hasCreatePermission(_ req: Request) -> Bool {
        req.checkPermission(createPermission())
    }
    
    static func hasUpdatePermission(_ req: Request) -> Bool {
        req.checkPermission(updatePermission())
    }
    
    static func hasDeletePermission(_ req: Request) -> Bool {
        req.checkPermission(deletePermission())
    }
}

public extension AdminController {
    
    static var moduleName: String { Model.Module.moduleKey.uppercasedFirst }
    static var modelName: FeatherModelName { .init(stringLiteral: Model.modelKey) }
    
    var context: AdminContext {
        .init(module: .init(key: Model.Module.moduleKey,
                            name: Model.Module.moduleKey.uppercasedFirst,
                            path: Model.Module.moduleKey),
              model: .init(key: Model.modelKey,
                           name: .init(singular: String(Model.modelKey.dropLast()).uppercasedFirst, plural: String(Model.modelKey.dropLast()).uppercasedFirst + "s"),
                           path: Model.modelKey,
                           idParamKey: Model.idParamKey))
    }
    
    func detailContext(_ req: Request, _ model: Model) -> AdminDetailPageContext {
        .init(title: Self.modelName.singular.uppercasedFirst + " details", fields: detailFields(for: model))
    }
    
    func listContext(_ req: Request, _ list: ListContainer<Model>) -> AdminListPageContext {
        let rows = list.items.map {
            RowContext(id: $0.identifier, cells: listCells(for: $0))
        }
        let table = TableContext(id: context.module.key + "-" + context.model.key + "-table",
                                 columns: listColumns(),
                                 rows: rows,
                                 actions: [
                                    Self.updateTableAction(),
                                    Self.deleteTableAction(),
                                 ])

        return .init(title: context.model.name.plural,
                     isSearchable: listConfig.isSearchable,
                     table: table,
                     pagination: list.info,
                     navigation: [
                        Self.createLink()
                     ],
                     breadcrumbs: [
                        Self.moduleLink(context.module.name),
                        Self.listLink(context.model.name.plural)
                     ])
    }
   
    func deleteContext(_ req: Request, _ model: Model, _ form: DeleteForm) -> AdminDeletePageContext {
        .init(title: "", name: deleteInfo(model), type: Self.modelName.singular, form: form.context(req))
    }
}

public extension AdminController {
    
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
}


public extension AdminController {

    func setupAdminRoutes(_ routes: RoutesBuilder) {
        let moduleRoutes = routes.grouped(.init(stringLiteral: Model.Module.moduleKey))
        let modelRoutes = moduleRoutes.grouped(.init(stringLiteral: Model.modelKey))
        
        modelRoutes.get(use: listView)
        
        modelRoutes.get(Self.createPathComponent, use: createView)
        modelRoutes.post(Self.createPathComponent, use: create)
        
        let existingModelRoutes = modelRoutes.grouped(Model.idParamKeyPathComponent)
        
        existingModelRoutes.get(use: detailView)
        
        existingModelRoutes.get(Self.updatePathComponent, use: updateView)
        existingModelRoutes.post(Self.updatePathComponent, use: update)
        
        existingModelRoutes.get(Self.deletePathComponent, use: deleteView)
        existingModelRoutes.post(Self.deletePathComponent, use: delete)
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
