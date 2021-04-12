//
//  QueryBuilder+Metadata.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

public extension QueryBuilder where Model: FeatherModel & MetadataRepresentable {

    /// join metadata and filter by draft and published status ordered by date
    func joinVisibleMetadata() -> QueryBuilder<Model> {
        joinMetadata()
            .filterVisible()
            .sortMetadataByDate()
    }

    /// join metadata and filter by published status, after the current date and order by date
    func joinPublicMetadata() -> QueryBuilder<Model> {
        joinMetadata()
            .filterMetadata(status: .published)
            .filterMetadata(before: Date())
            .sortMetadataByDate()
    }

    /// joins the metadata object on the ViperModel query, if a path is present it'll use it as a filter to return only one instance that matches the slug
    func joinMetadata() -> QueryBuilder<Model> {
        join(SystemMetadataModel.self, on: \SystemMetadataModel.$reference == \Model._$id)
                    .filter(SystemMetadataModel.self, \.$module == Model.Module.name)
                    .filter(SystemMetadataModel.self, \.$model == Model.name)
    }
    
    /// find an object with an associated the metadata object for a given path
    func filterMetadata(path: String) -> QueryBuilder<Model> {
        filter(SystemMetadataModel.self, \.$slug == path.trimmingSlashes())
    }

    /// find an object with a given status
    func filterMetadata(status: Metadata.Status) -> QueryBuilder<Model> {
        filter(SystemMetadataModel.self, \.$status == status)
    }
    
    /// find an object with associated draft or published status
    func filterVisible() -> QueryBuilder<Model> {
        filter(SystemMetadataModel.self, \.$status != .archived)
    }

    /// date earlier than x
    func filterMetadata(before date: Date) -> QueryBuilder<Model> {
        filter(SystemMetadataModel.self, \.$date <= date)
    }

    /// sort metadata by date in a given direction
    func sortMetadataByDate(_ direction: DatabaseQuery.Sort.Direction = .descending) -> QueryBuilder<Model> {
        sort(SystemMetadataModel.self, \.$date, direction)
    }
}
