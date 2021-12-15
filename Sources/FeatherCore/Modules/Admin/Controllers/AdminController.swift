//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 29..
//

import Foundation
import Vapor

public protocol AdminController: FeatherController {

    var createPathComponent: PathComponent { get }
    var updatePathComponent: PathComponent { get }
    var deletePathComponent: PathComponent { get }
    
    var context: AdminContext { get }

//    var moduleName: String { get }
//    var modelName: FeatherModelName { get }

    func listContext(_ req: Request, _ list: ListContainer<Model>) -> AdminListPageContext
    func listColumns() -> [ColumnContext]
    func listCells(for model: Model) -> [CellContext]
    func detailContext(_ req: Request, _ model: Model) -> AdminDetailPageContext
    func deleteContext(_ req: Request, _ model: Model, _ form: DeleteForm) -> AdminDeletePageContext
    
//    var listLink: LinkContext { get }
//    func createLink() -> LinkContext
//    func detailLink(for id: UUID) -> LinkContext
//    func updateLink(for id: UUID) -> LinkContext
//    func deleteLink(for id: UUID) -> LinkContext
    
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

//    var moduleName: String { Model.Module.moduleKey.uppercasedFirst }
    
    func modulePath() -> String {
        "/admin/" + Model.Module.moduleKey
    }

    func listPath() -> String {
        "/admin/" + Model.Module.moduleKey + "/" + Model.modelKey
    }

    func createPath() -> String {
        listPath() + "/create/"
    }

    func moduleLink(_ label: String) -> LinkContext {
        .init(label: label, url: modulePath())
    }
    
    func listLink(_ label: String = "List") -> LinkContext {
        .init(label: label, url: listPath(), permission: listPermission())
    }
    
    func createLink(_ label: String = "Create new") -> LinkContext {
        .init(label: label, url: createPath(), permission: createPermission())
    }

    func detailLink(_ label: String = "Details", id: UUID) -> LinkContext {
        .init(label: label, url: listPath() + "/" + id.uuidString + "/", permission: detailPermission())
    }
    
    func updateTableAction(_ label: String = "Update") -> LinkContext {
        .init(label: label, url: listPath() + "/:rowId/update/", permission: updatePermission())
    }
    
    func deleteTableAction(_ label: String = "Delete") -> LinkContext {
        .init(label: label, url: listPath() + "/:rowId/delete/", permission: deletePermission())
    }
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
    
//    private var listComponents: [PathComponent] {
//        [
//            Feather.config.paths.admin.pathComponent,
//            Model.Module.modulePathComponent,
//            Model.modelPathComponent
//        ]
//    }

//    var listLink: LinkContext {
//        return .init(label: context.model.name.plural,
//                     url: listComponents.string.safePath(),
//                     permission: Model.permission(.list).rawValue)
//    }
//
//    func createLink() -> LinkContext {
//        var components = listComponents
//        components.append(createPathComponent)
//        return .init(label: context.model.name.singular,
//                     url: components.string.safePath(),
//                     permission: Model.permission(.create).rawValue)
//    }
//
//    func detailLink(for id: UUID) -> LinkContext {
//        var components = listComponents
//        components.append(.init(stringLiteral: id.uuidString))
//        return .init(label: context.model.name.singular,
//                     url: components.string.safePath(),
//                     permission: Model.permission(.detail).rawValue)
//    }
//
//    func updateLink(for id: UUID) -> LinkContext {
//        var components = listComponents
//        components.append(.init(stringLiteral: id.uuidString))
//        components.append(updatePathComponent)
//        return .init(label: context.model.name.singular,
//                     url: components.string.safePath(),
//                     permission: Model.permission(.update).rawValue)
//    }
//
//    func deleteLink(for id: UUID) -> LinkContext {
//        var components = listComponents
//        components.append(.init(stringLiteral: id.uuidString))
//        components.append(deletePathComponent)
//        return .init(label: context.model.name.singular,
//                     url: components.string.safePath(),
//                     permission: Model.permission(.delete).rawValue)
//    }

    // MARK: - templates
    
    func listTemplate(_ req: Request, _ list: ListContainer<Model>) -> TemplateRepresentable {
        AdminListPageTemplate(req, listContext(req, list))
    }
    
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


