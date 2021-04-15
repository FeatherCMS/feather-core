//
//  ViperModel+Metadata.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 11. 14..
//

public extension FeatherModel where Self: MetadataRepresentable {

    // MARK: - content filter api
    /// invokes content filters that are associated to the metadata object
    func filter(_ content: String, req: Request) -> EventLoopFuture<String> {
        
        guard let enabledFilters = joinedMetadata?.filters else {
            return req.eventLoop.future(content)
        }
        /// invoke available filtes, filter them by enabled keys & transform the result using the futures...
        let contentFilters: [[ContentFilter]] = req.invokeAll("content-filters")
        let flatFilteredFilters = contentFilters.flatMap { $0 }.filter { enabledFilters.contains($0.key) }.sorted { $0.priority > $1.priority }
        var result: EventLoopFuture<String> = req.eventLoop.future(content)
        for f in flatFilteredFilters {
            result = result.flatMap { res in f.filter(res, req) }
        }
        return result
    }


    // MARK: - find metadata info

    static func findMetadata(reference: UUID, on db: Database) -> EventLoopFuture<Metadata?> {
        SystemMetadataModel.query(on: db)
            .filter(\.$module == Module.name)
            .filter(\.$model == name)
            .filter(\.$reference == reference)
            .first()
            .map { $0?.metadata }
    }

    // MARK: - joined metadata api
    
    /// returns the joined metadata model as a dictionary or an empty dictionary
    var joinedMetadata: Metadata? {
        try? joined(SystemMetadataModel.self).metadata
    }

    /// joins the metadata object on the ViperModel query, if a path is present it'll use it as a filter to return only one instance that matches the slug
    static func queryJoinPublicMetadata(on db: Database) -> QueryBuilder<Self> {
        query(on: db).joinPublicMetadata()
    }

    /// find an object with an associated the metadata object for a given path
    static func queryJoinPublicMetadata(path: String, on db: Database) -> QueryBuilder<Self> {
        queryJoinPublicMetadata(on: db).filterMetadata(path: path)
    }
    
    /// find an object with an associated published or draft metadata
    static func queryJoinVisibleMetadata(on db: Database) -> QueryBuilder<Self> {
        query(on: db).joinVisibleMetadata()
    }
    
    /// find an object with an associated published or draft metadata for a given path
    static func queryJoinVisibleMetadata(path: String, on db: Database) -> QueryBuilder<Self> {
        queryJoinVisibleMetadata(on: db).filterMetadata(path: path)
    }
    
    // MARK: - update associated metadata

    /// update metadata object
    func updateMetadata(on db: Database, _ block: @escaping () -> Metadata) -> EventLoopFuture<Void> {
        var metadata = block()
        metadata.reference = id!
        metadata.model = Self.name
        metadata.module = Module.name
        
        return SystemMetadataModel.query(on: db)
                    .filter(\.$module == metadata.module!)
                    .filter(\.$model == metadata.model!)
                    .filter(\.$reference == metadata.reference!)
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .flatMap { model -> EventLoopFuture<Void> in
                        model.use(metadata)
                        return model.update(on: db)
                    }
    }

    /// publish a metadata object
    func publishMetadata(on db: Database) -> EventLoopFuture<Void> {
        updateMetadata(on: db) {
            Metadata(status: .published)
        }
    }

    /// publish a metadata object as a home item
    func publishMetadataAsHome(on db: Database) -> EventLoopFuture<Void> {
        updateMetadata(on: db) {
            Metadata(slug: "", status: .published)
        }
    }
}

public extension FeatherModel where Self: MetadataRepresentable {

    /// returns the default template data object coinaining the metadata template data (metadata info must be already joined / present)
    var templateDataWithJoinedMetadata: TemplateData {
        var data: [String: TemplateData] = encodeToTemplateData().dictionary!
        data["metadata"] = joinedMetadata?.encodeToTemplateData() ?? .dictionary(nil)
        return .dictionary(data)
    }
}
