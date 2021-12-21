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
                                    LinkContext(label: "Update", path: Self.updatePathComponent.description),
                                    LinkContext(label: "Delete", path: Self.deletePathComponent.description),
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
            LinkContext(label: "Create",
                        path: Self.createPathComponent.description,
                        permission: Self.createPermission())
        ]
    }
    
    func listBreadcrumbs(_ req: Request) -> [LinkContext] {
        [
            LinkContext(label: Model.Module.moduleKey.uppercasedFirst,
                        dropLast: 1,
                        permission: Model.Module.permission.key),
        ]
    }

    func detailContext(_ req: Request, _ model: Model) -> AdminDetailPageContext {
        .init(title: Self.modelName.singular.uppercasedFirst + " details",
              fields: detailFields(for: model),
              breadcrumbs: detailBreadcrumbs(req, model),
              links: detailLinks(req, model),
              actions: [
                LinkContext(label: "Delete",
                            path: Self.deletePathComponent.description,
                            permission: Self.deletePermission(),
                            style: .destructive),
              ])
    }

    func detailBreadcrumbs(_ req: Request, _ model: Model) -> [LinkContext] {
        [
            LinkContext(label: Model.Module.moduleKey.uppercasedFirst,
                        dropLast: 2,
                        permission: Model.Module.permission.key),
            LinkContext(label: Self.modelName.plural.uppercasedFirst,
                        dropLast: 1,
                        permission: Self.listPermission()),
        ]
    }

    func detailLinks(_ req: Request, _ model: Model) -> [LinkContext] {
        [
            LinkContext(label: "Update",
                        path: Self.updatePathComponent.description,
                        permission: Self.updatePermission()),
        ]
    }

    func createContext(_ req: Request, _ editor: CreateModelEditor) -> AdminEditorPageContext {
        .init(title: "Create " + Self.modelName.singular,
              form: editor.form.context(req),
              breadcrumbs: createBreadcrumbs(req))
    }
    
    func createBreadcrumbs(_ req: Request) -> [LinkContext] {
        [
            LinkContext(label: Model.Module.moduleKey.uppercasedFirst,
                        dropLast: 2,
                        permission: Model.Module.permission.key),
            LinkContext(label: Self.modelName.plural.uppercasedFirst,
                        dropLast: 1,
                        permission: Self.listPermission()),
        ]
    }
    
    func updateContext(_ req: Request, _ editor: UpdateModelEditor) async -> AdminEditorPageContext {
       .init(title: "Update " + Self.modelName.singular,
             form: editor.form.context(req),
             breadcrumbs: updateBreadcrumbs(req, editor.model as! Model),
             links: updateLinks(req, editor.model as! Model),
             actions: [
                LinkContext(label: "Delete",
                            path: Self.deletePathComponent.description,
                            dropLast: 1,
                            permission: Self.deletePermission(),
                            style: .destructive),
             ])
    }
    
    func updateBreadcrumbs(_ req: Request, _ model: Model) -> [LinkContext] {
        [
            LinkContext(label: Model.Module.moduleKey.uppercasedFirst,
                        dropLast: 3,
                        permission: Model.Module.permission.key),
            LinkContext(label: Self.modelName.plural.uppercasedFirst,
                        dropLast: 2,
                        permission: Self.listPermission()),
        ]
    }
    
    func updateLinks(_ req: Request, _ model: Model) -> [LinkContext] {
        [
            LinkContext(label: "Details",
                        dropLast: 1,
                        permission: Self.detailPermission()),
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
