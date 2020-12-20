//
//  QueryBuilder+Metadata.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

public extension QueryBuilder where Model: MetadataModel {

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
        Feather.metadataDelegate?.join(queryBuilder: self) ?? self
    }
    
    /// find an object with an associated the metadata object for a given path
    func filterMetadata(path: String) -> QueryBuilder<Model> {
        Feather.metadataDelegate?.filter(queryBuilder: self, path: path) ?? self
    }

    /// find an object with a given status
    func filterMetadata(status: Metadata.Status) -> QueryBuilder<Model> {
        Feather.metadataDelegate?.filter(queryBuilder: self, status: status) ?? self
    }
    
    /// find an object with associated draft or published status
    func filterVisible() -> QueryBuilder<Model> {
        Feather.metadataDelegate?.filterVisible(queryBuilder: self) ?? self
    }

    /// date earlier than x
    func filterMetadata(before date: Date) -> QueryBuilder<Model> {
        Feather.metadataDelegate?.filter(queryBuilder: self, before: date) ?? self
    }

    /// sort metadata by date in a given direction
    func sortMetadataByDate(_ direction: DatabaseQuery.Sort.Direction = .descending) -> QueryBuilder<Model> {
        Feather.metadataDelegate?.sortByDate(queryBuilder: self, direction: direction) ?? self
    }
}
