//
//  ViperModel+Metadata.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 11. 14..
//

public extension ViperModel where Self: MetadataRepresentable {

    // MARK: - content filter api
    /// invokes content filters that are associated to the metadata object
    func filter(_ content: String, req: Request) -> String {
        guard let metadataFilters = joinedMetadata?.filters else {
            return content
        }
        /// if the user explicitly disabled filters we can return the content
        if metadataFilters.contains("[disable-all-filters]") {
            return content
        }
        let result: [[ContentFilter]] = req.invokeAll("content-filters")

        /// we use the default filters if there was no selected filter for the metadata
        var filters: [String] = []
        if
            metadataFilters.isEmpty,
            let variables = req.cache["system.variables"] as? [String:Any],
            let defaultFilters = variables["frontend.site.filters"] as? String
        {
            filters = defaultFilters.split(separator: ",").map { String($0) }
        }
        else {
            filters = metadataFilters
        }
        return result
            .flatMap { $0 }
            .filter { filters.contains($0.key) }
            .reduce(content) { $1.filter($0) }
    }


    // MARK: - find metadata info

    static func findMetadata(id: UUID, on db: Database) -> EventLoopFuture<Metadata?> {
        Feather.metadataDeletage?.find(id: id, on: db) ?? db.eventLoop.future(nil)
    }

    // MARK: - joined metadata api
    
    /// returns the joined metadata model as a dictionary or an empty dictionary
    var joinedMetadata: Metadata? {
        Feather.metadataDeletage?.joinedMetadata
    }

    /// joins the metadata object on the ViperModel query, if a path is present it'll use it as a filter to return only one instance that matches the slug
    static func queryJoinPublicMetadata(on db: Database) -> QueryBuilder<Self> {
        query(on: db).joinPublicMetadata()
    }

    /// find an object with an associated the metadata object for a given path
    static func queryJoinPublicMetadata(path: String, on db: Database) -> QueryBuilder<Self> {
        queryJoinPublicMetadata(on: db).filterMetadata(path: path)
    }
    
    // MARK: - update associated metadata

    /// update metadata object
    func updateMetadata(on db: Database, _ block: @escaping () -> Metadata) -> EventLoopFuture<Void> {
        var metadata = block()
        metadata.reference = id!
        metadata.model = Self.name
        metadata.module = Module.name
        return Feather.metadataDeletage?.update(metadata, on: db) ?? db.eventLoop.future()
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

public extension ViperModel where Self: MetadataRepresentable, Self: LeafDataRepresentable {

    /// returns the default leaf data object coinaining the metadata leaf data (metadata info must be already joined / present)
    var leafDataWithJoinedMetadata: LeafData {
        var data: [String: LeafData] = leafData.dictionary!
        data["metadata"] = joinedMetadata?.leafData ?? .dictionary(nil)
        return .dictionary(data)
    }
}
