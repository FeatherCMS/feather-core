//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 29..
//

import Foundation
import Vapor

public protocol AdminController: FeatherController {

    // MARK: - context
    
    //    var moduleName: String { get }
    //    var modelName: FeatherModelName { get }

    var context: AdminContext { get }
    
    func listContext(_ req: Request, _ list: ListContainer<Model>) -> AdminListPageContext
    func listColumns() -> [ColumnContext]
    func listCells(for model: Model) -> [CellContext]
    func detailContext(_ req: Request, _ model: Model) -> AdminDetailPageContext
    func deleteContext(_ req: Request, _ model: Model, _ form: DeleteForm) -> AdminDeletePageContext
    
    // MARK: - path components
    
    var createPathComponent: PathComponent { get }
    var updatePathComponent: PathComponent { get }
    var deletePathComponent: PathComponent { get }
    
    var modulePathComponents: [PathComponent] { get }
    var listPathComponents: [PathComponent] { get }
    var createPathComponents: [PathComponent] { get }
    func detailPathComponents(for id: UUID) -> [PathComponent]
    func updatePathComponents(for id: UUID) -> [PathComponent]
    func deletePathComponents(for id: UUID) -> [PathComponent]
    
    var rowIdPathComponents: [PathComponent] { get }
    var rowUpdatePathComponents: [PathComponent] { get }
    var rowDeletePathComponents: [PathComponent] { get }
    
    func moduleLink(_ label: String) -> LinkContext
    func listLink(_ label: String) -> LinkContext
    func createLink(_ label: String) -> LinkContext
    func detailLink(_ label: String, id: UUID) -> LinkContext
    func updateTableAction(_ label: String) -> LinkContext
    func deleteTableAction(_ label: String) -> LinkContext

    
    // MARK: - permission
    
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
    //    var moduleName: String { Model.Module.moduleKey.uppercasedFirst }
    
    var context: AdminContext {
        .init(module: .init(key: Model.Module.moduleKey,
                            name: Model.Module.moduleKey.uppercasedFirst,
                            path: Model.Module.moduleKey),
              model: .init(key: Model.modelKey,
                           name: .init(singular: String(Model.modelKey.dropLast()).uppercasedFirst, plural: String(Model.modelKey.dropLast()).uppercasedFirst + "s"),
                           path: Model.modelKey,
                           idParamKey: Model.idParamKey))
    }
}

public extension AdminController {

    var createPathComponent: PathComponent { "create" }
    var updatePathComponent: PathComponent { "update" }
    var deletePathComponent: PathComponent { "delete" }

    var modulePathComponents: [PathComponent] {
        [
            Feather.config.paths.admin.pathComponent,
            Model.Module.pathComponent,
        ]
    }

    var listPathComponents: [PathComponent] {
        modulePathComponents + [Model.pathComponent]
    }
    
    var createPathComponents: [PathComponent] {
        listPathComponents + [createPathComponent]
    }
    
    func detailPathComponents(for id: UUID) -> [PathComponent] {
        listPathComponents + [.init(stringLiteral: id.uuidString)]
    }
    
    func updatePathComponents(for id: UUID) -> [PathComponent] {
        detailPathComponents(for: id) + [updatePathComponent]
    }
    
    func deletePathComponents(for id: UUID) -> [PathComponent] {
        detailPathComponents(for: id) + [deletePathComponent]
    }
    
    var rowIdPathComponents: [PathComponent] {
        listPathComponents + [":rowId"]
    }
    
    var rowUpdatePathComponents: [PathComponent] {
        rowIdPathComponents + [updatePathComponent]
    }
    
    var rowDeletePathComponents: [PathComponent] {
        rowIdPathComponents + [deletePathComponent]
    }

    func moduleLink(_ label: String) -> LinkContext {
        .init(label: label, url: modulePathComponents.string)
    }
    
    func listLink(_ label: String = "List") -> LinkContext {
        .init(label: label, url: listPathComponents.string, permission: listPermission())
    }
    
    func createLink(_ label: String = "Create new") -> LinkContext {
        .init(label: label, url: createPathComponents.string, permission: createPermission())
    }

    func detailLink(_ label: String = "Details", id: UUID) -> LinkContext {
        .init(label: label, url: detailPathComponents(for: id).string, permission: detailPermission())
    }
    
    func updateTableAction(_ label: String = "Update") -> LinkContext {
        .init(label: label, url: rowUpdatePathComponents.string, permission: updatePermission())
    }

    func deleteTableAction(_ label: String = "Delete") -> LinkContext {
        .init(label: label, url: rowDeletePathComponents.string, permission: deletePermission())
    }
}

public extension AdminController {
    

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
}

public extension AdminController {
    
    func listContext(_ req: Request, _ list: ListContainer<Model>) -> AdminListPageContext {
        let rows = list.items.map {
            RowContext(id: $0.identifier, cells: listCells(for: $0))
        }
        let table = TableContext(id: context.module.key + "-" + context.model.key + "-table",
                                 columns: listColumns(),
                                 rows: rows,
                                 actions: [
                                    updateTableAction(),
                                    deleteTableAction(),
                                 ])

        return .init(title: context.model.name.plural,
                     isSearchable: listConfig.isSearchable,
                     table: table,
                     pagination: list.info,
                     navigation: [
                        createLink()
                     ],
                     breadcrumbs: [
                        moduleLink(context.module.name),
                        listLink(context.model.name.plural)
                     ])
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
