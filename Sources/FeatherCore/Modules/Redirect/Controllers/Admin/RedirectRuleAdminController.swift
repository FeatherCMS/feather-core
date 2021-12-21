//
//  RedirectRuleAdminController.swift
//  
//
//  Created by Steve Tibbett on 2021-12-19
//

import Vapor
import Fluent

struct RedirectRuleAdminController: AdminController {
    
    typealias Model = RedirectRuleModel
    
    typealias CreateModelEditor = RedirectRuleEditor
    typealias UpdateModelEditor = RedirectRuleEditor

    typealias ListModelApi = RedirectRuleApi
    typealias DetailModelApi = RedirectRuleApi
    typealias CreateModelApi = RedirectRuleApi
    typealias UpdateModelApi = RedirectRuleApi
    typealias PatchModelApi = RedirectRuleApi
    typealias DeleteModelApi = RedirectRuleApi
     
    
    func findBy(_ id: UUID, on db: Database) async throws -> Model {
        guard let model = try await Model.find(id, on: db) else {
            throw Abort(.notFound)
        }
        return model
    }

    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            "source",
            "destination"
        ], defaultSort: .desc)
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<Model>] {
        [
            \.$source ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init("source"),
            .init("destination"),
            .init("statusCode"),
        ]
    }
    
    func listCells(for model: Model) -> [CellContext] {
        [
            .init(model.source), //, link: LinkContext(label: model.title, permission: Self.detailPermission()), type: .image),
            .init(model.destination), //, link: LinkContext(label: model.title, permission: Self.detailPermission())),
            .init(String(model.statusCode)),
        ]
    }
    
    func detailFields(for model: Model) -> [FieldContext] {
        [
            .init("id", model.identifier),
            .init("source", model.source, label: "Source path (ie, \"/foo\")"),
            .init("destination", model.destination, label: "Destination URL or path"),
            // TODO - status code should be a select
            .init("statusCode", String(model.statusCode), label: "HTTP status code (303=normal, 301=permanent, 307=temporary)"),
            .init("notes", model.notes)
        ]
    }

    func deleteInfo(_ model: Model) -> String {
        model.source
    }
}
