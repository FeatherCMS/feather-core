//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import Fluent

struct WebMenuAdminController: AdminController {
    typealias Model = WebMenuModel
    
    typealias CreateModelEditor = WebMenuEditor
    typealias UpdateModelEditor = WebMenuEditor
    
    typealias ListModelApi = WebMenuApi
    typealias DetailModelApi = WebMenuApi
    typealias CreateModelApi = WebMenuApi
    typealias UpdateModelApi = WebMenuApi
    typealias PatchModelApi = WebMenuApi
    typealias DeleteModelApi = WebMenuApi

    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            "name",
        ])
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<Model>] {
        [
            \.$name ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init("name"),
        ]
    }
    
    func listCells(for model: Model) -> [CellContext] {
        [
            .init(model.name, link: LinkContext(label: model.name, permission: Self.detailPermission())),
        ]
    }
    
    func detailFields(for model: Model) -> [FieldContext] {
        [
            .init("id", model.identifier),
            .init("key", model.key),
            .init("name", model.name),
            .init("notes", model.notes),
        ]
    }
    
    func detailLinks(_ req: Request, _ model: Model) -> [LinkContext] {
        [
            LinkContext(label: "Update",
                        path: Self.updatePathComponent.description,
                        permission: Self.updatePermission()),
            LinkContext(label: WebMenuItemAdminController.modelName.plural.uppercasedFirst,
                        path: WebMenuItemModel.pathComponent.description,
                        permission: WebMenuItemAdminController.listPermission()),
        ]
    }
    
    func deleteInfo(_ model: Model) -> String {
        model.key
    }
}
