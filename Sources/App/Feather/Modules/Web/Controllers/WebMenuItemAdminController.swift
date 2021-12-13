//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import Fluent

struct WebMenuItemController: AdminController {
    
    typealias Model = WebMenuItemModel
    
    typealias CreateModelEditor = WebMenuItemEditor
    typealias UpdateModelEditor = WebMenuItemEditor
    
    typealias ListModelApi = WebMenuItemApi
    typealias DetailModelApi = WebMenuItemApi
    typealias CreateModelApi = WebMenuItemApi
    typealias UpdateModelApi = WebMenuItemApi
    typealias PatchModelApi = WebMenuItemApi
    typealias DeleteModelApi = WebMenuItemApi
    
    // MARK: - list
    
    var listConfig: ListConfiguration {
        .init(allowedOrders: [
//            Model.FieldKeys.v1.key,
//            Model.FieldKeys.v1.name,
//            Model.FieldKeys.v1.value,
        ], defaultSort: .asc)
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<Model>] {
        [
//            \.$key ~~ term,
//            \.$name ~~ term,
//            \.$value ~~ term,
//            \.$notes ~~ term,
        ]
    }
    
    func listContext(_ req: Request, _ list: ListContainer<Model>) -> AdminListPageContext {
        let rows = list.items.map {
            RowContext(id: $0.identifier, cells: [
//                .init($0.key, link: .init(label: $0.key, url: "/", permission: detailPermission())),
//                .init($0.value),
            ])
        }
        let table = TableContext(id: "",
                                 columns: [
//                                    .init(Model.FieldKeys.v1.key.description, isDefault: true),
//                                    .init(Model.FieldKeys.v1.value.description),
                                 ],
                                 rows: rows,
                                 actions: [
                                    .init(label: "Update", url: "/update/", permission: updatePermission()),
                                    .init(label: "Delete", url: "/delete/", permission: deletePermission()),
                                 ])

        return .init(title: context.model.name.plural,
                     isSearchable: listConfig.isSearchable,
                     table: table,
                     pagination: list.info,
                     navigation: [
                        .init(label: "Create new", url: "/create/", permission: createPermission()),
                     ],
                     breadcrumbs: [
                        .init(label: "Common", url: "/admin/common/")
                     ])
    }
    
    // MARK: - detail
    
    func detailContext(_ req: Request, _ model: Model) -> AdminDetailPageContext {
        .init(title: "Variable details", fields: [
            .init(label: "Id", value: model.identifier),
//            .init(label: "Key", value: model.key),
//            .init(label: "Name", value: model.name),
//            .init(label: "Value", value: model.value ?? ""),
//            .init(label: "Notes", value: model.notes ?? ""),
        ])
    }

    // MARK: - delete
    
    func deleteContext(_ req: Request, _ model: Model, _ form: DeleteForm) -> AdminDeletePageContext {
        .init(title: "", name: model.label, type: "menu item", form: form.context(req))
    }
}