//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//


public extension QueryBuilder where Model: ViperModel & MetadataRepresentable {

    func joinPublicMetadata() -> QueryBuilder<Model> {
        joinMetadata()
            .filterMetadata(status: .published)
            .filterMetadata(before: Date())
            .sortMetadataByDate()
    }

    /// joins the metadata object on the ViperModel query, if a path is present it'll use it as a filter to return only one instance that matches the slug
    func joinMetadata() -> QueryBuilder<Model> {
        join(FrontendMetadataModel.self, on: \FrontendMetadataModel.$reference == \Model._$id)
            .filter(FrontendMetadataModel.self, \.$module == Model.Module.name)
            .filter(FrontendMetadataModel.self, \.$model == Model.name)
    }
    
    /// find an object with an associated the metadata object for a given path
    func filterMetadata(path: String) -> QueryBuilder<Model> {
        filter(FrontendMetadataModel.self, \.$slug == path.trimmingSlashes())
    }

    /// find an object with associated public (status is published & date is in the past) metadatas ordered by date descending
    func filterMetadata(status: Metadata.Status) -> QueryBuilder<Model> {
        filter(FrontendMetadataModel.self, \.$status == status)
    }

    /// date earlier than x
    func filterMetadata(before date: Date) -> QueryBuilder<Model> {
        filter(FrontendMetadataModel.self, \.$date <= date)
    }

    func sortMetadataByDate(_ direction: DatabaseQuery.Sort.Direction = .descending) -> QueryBuilder<Model> {
        sort(FrontendMetadataModel.self, \.$date, direction)
    }
}
