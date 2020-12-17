//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//


public extension QueryBuilder where Model: ViperModel & MetadataRepresentable {

    func joinPublicMetadata(req: Request) -> QueryBuilder<Model> {
        joinMetadata(req: req)
            .filterMetadata(status: .published, req: req)
            .filterMetadata(before: Date(), req: req)
            .sortMetadataByDate(req: req)
    }

    /// joins the metadata object on the ViperModel query, if a path is present it'll use it as a filter to return only one instance that matches the slug
    func joinMetadata(req: Request) -> QueryBuilder<Model> {
        let res: QueryBuilder<Model>? = req.invoke("metadata-query-join", args: [
            "query-builder": self
        ])
        return res ?? self
    }
    
    /// find an object with an associated the metadata object for a given path
    func filterMetadata(path: String, req: Request) -> QueryBuilder<Model> {
        let res: QueryBuilder<Model>? = req.invoke("metadata-query-filter", args: [
            "query-builder": self,
            "path": path,
        ])
        return res ?? self
    }

    /// find an object with associated public (status is published & date is in the past) metadatas ordered by date descending
    func filterMetadata(status: Metadata.Status, req: Request) -> QueryBuilder<Model> {
        let res: QueryBuilder<Model>? = req.invoke("metadata-query-filter", args: [
            "query-builder": self,
            "status": status,
        ])
        return res ?? self
    }

    /// date earlier than x
    func filterMetadata(before date: Date, req: Request) -> QueryBuilder<Model> {
        let res: QueryBuilder<Model>? = req.invoke("metadata-query-filter", args: [
            "query-builder": self,
            "before-date": date,
        ])
        return res ?? self
    }

    func sortMetadataByDate(_ direction: DatabaseQuery.Sort.Direction = .descending, req: Request) -> QueryBuilder<Model> {
        let res: QueryBuilder<Model>? = req.invoke("metadata-query-sort", args: [
            "query-builder": self,
            "order": "date",
            "direction": direction,
        ])
        return res ?? self
    }
}
