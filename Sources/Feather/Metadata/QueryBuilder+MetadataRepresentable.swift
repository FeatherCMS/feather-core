//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import FeatherApi

public extension QueryBuilder where Model: MetadataRepresentable {

    func joinMetadata() -> QueryBuilder<Model> {
        join(SystemMetadataModel.self, on: \SystemMetadataModel.$reference == \Model._$id)
            .filter(SystemMetadataModel.self, \.$module == Model.Module.uniqueKey)
            .filter(SystemMetadataModel.self, \.$model == Model.uniqueKey)
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
        filter(SystemMetadataModel.self, \.$slug == path.trimmingSlashes())
    }

    func filterMetadataBy(status: FeatherMetadata.Status) -> QueryBuilder<Model> {
        filter(SystemMetadataModel.self, \.$status == status)
    }

    func filterMetadataByVisibleStatus() -> QueryBuilder<Model> {
        filter(SystemMetadataModel.self, \.$status != .archived)
    }

    func filterMetadataBy(date: Date) -> QueryBuilder<Model> {
        filter(SystemMetadataModel.self, \.$date <= date)
    }

    func sortMetadataByDate(_ direction: DatabaseQuery.Sort.Direction = .descending) -> QueryBuilder<Model> {
        sort(SystemMetadataModel.self, \.$date, direction)
    }
}
