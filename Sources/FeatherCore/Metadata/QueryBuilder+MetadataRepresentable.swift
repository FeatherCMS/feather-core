//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Vapor
import Fluent
import FeatherCoreApi

public extension QueryBuilder where Model: MetadataRepresentable {

    func joinMetadata() -> QueryBuilder<Model> {
        join(WebMetadataModel.self, on: \WebMetadataModel.$reference == \Model._$id)
            .filter(WebMetadataModel.self, \.$module == Model.Module.pathComponent.description)
            .filter(WebMetadataModel.self, \.$model == Model.pathComponent.description)
    }

    func joinVisibleMetadata() -> QueryBuilder<Model> {
        joinMetadata()
            .filterMetadataByVisibleStatus()
    }

    func joinPublicMetadata() -> QueryBuilder<Model> {
        joinMetadata()
            .filterMetadataBy(status: .published)
            .filterMetadataBy(date: Date())
    }

    func filterMetadataBy(path: String) -> QueryBuilder<Model> {
        filter(WebMetadataModel.self, \.$slug == path.trimmingSlashes())
    }

    func filterMetadataBy(status: WebMetadata.Status) -> QueryBuilder<Model> {
        filter(WebMetadataModel.self, \.$status == status)
    }

    func filterMetadataByVisibleStatus() -> QueryBuilder<Model> {
        filter(WebMetadataModel.self, \.$status != .archived)
    }

    func filterMetadataBy(date: Date) -> QueryBuilder<Model> {
        filter(WebMetadataModel.self, \.$date <= date)
    }

    func sortMetadataByDate(_ direction: DatabaseQuery.Sort.Direction = .descending) -> QueryBuilder<Model> {
        sort(WebMetadataModel.self, \.$date, direction)
    }
}
