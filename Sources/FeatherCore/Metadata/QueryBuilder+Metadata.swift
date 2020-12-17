//
//  QueryBuilder+Metadata.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

public extension QueryBuilder where Model: MetadataModel {

    func joinPublicMetadata() -> QueryBuilder<Model> {
        joinMetadata()
            .filterMetadata(status: .published)
            .filterMetadata(before: Date())
            .sortMetadataByDate()
    }

    /// joins the metadata object on the ViperModel query, if a path is present it'll use it as a filter to return only one instance that matches the slug
    func joinMetadata() -> QueryBuilder<Model> {
        Feather.metadataDeletage?.join(queryBuilder: self) ?? self
    }
    
    /// find an object with an associated the metadata object for a given path
    func filterMetadata(path: String) -> QueryBuilder<Model> {
        Feather.metadataDeletage?.filter(queryBuilder: self, path: path) ?? self
    }

    /// find an object with associated public (status is published & date is in the past) metadatas ordered by date descending
    func filterMetadata(status: Metadata.Status) -> QueryBuilder<Model> {
        Feather.metadataDeletage?.filter(queryBuilder: self, status: status) ?? self
    }

    /// date earlier than x
    func filterMetadata(before date: Date) -> QueryBuilder<Model> {
        Feather.metadataDeletage?.filter(queryBuilder: self, before: date) ?? self
    }

    func sortMetadataByDate(_ direction: DatabaseQuery.Sort.Direction = .descending) -> QueryBuilder<Model> {
        Feather.metadataDeletage?.sortByDate(queryBuilder: self, direction: direction) ?? self
    }
}
