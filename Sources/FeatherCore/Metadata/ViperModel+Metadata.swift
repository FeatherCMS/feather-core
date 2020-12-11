//
//  ViperModel+LeafDataWithMetadata.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 11. 14..
//


public extension ViperModel where Self: MetadataRepresentable {

    // MARK: - content filter api

    /// invokes content filters that are associated to the metadata object
    func filter(_ content: String, req: Request) -> String {
        guard let metadata = joinedMetadataModel else {
            return content
        }
        let result: [[ContentFilter]] = req.invokeAll("content-filters")
        return result.flatMap { $0 }.filter { metadata.filters.contains($0.key) }.reduce(content) { $1.filter($0) }
    }


    // MARK: - find metadata info
    
    private static func findMetadataModelBy(id: UUID, on db: Database) -> EventLoopFuture<FrontendMetadataModel?> {
        FrontendMetadataModel.query(on: db)
            .filter(\.$module == Module.name)
            .filter(\.$model == name)
            .filter(\.$reference == id)
            .first()
    }

    static func findMetadataBy(id: UUID, on db: Database) -> EventLoopFuture<Metadata?> {
        findMetadataModelBy(id: id, on: db).map { $0?.metadata }
    }

    // MARK: - joined metadata api

    private var joinedMetadataModel: FrontendMetadataModel? {
        try? joined(FrontendMetadataModel.self)
    }
    
    /// returns the joined metadata model as a dictionary or an empty dictionary
    var joinedMetadata: Metadata? {
        joinedMetadataModel?.metadata
    }

    /// joins the metadata object on the ViperModel query, if a path is present it'll use it as a filter to return only one instance that matches the slug
    static func queryPublicMetadata(on db: Database) -> QueryBuilder<Self> {
        query(on: db).joinPublicMetadata()
    }

    /// find an object with an associated the metadata object for a given path
    static func queryPublicMetadata(path: String, on db: Database) -> QueryBuilder<Self> {
        queryPublicMetadata(on: db).filterMetadata(path: path)
    }
    
    // MARK: - update associated metadata

    /// private helper to find associated metadata object
    private func findMetadataReference(on db: Database) -> EventLoopFuture<FrontendMetadataModel> {
        FrontendMetadataModel.query(on: db)
            .filter(\.$reference == id!)
            .filter(\.$module == Self.Module.name)
            .filter(\.$model == Self.name)
            .first()
            .unwrap(or: Abort(.notFound, reason: "Metadata not found"))
    }

    /// update metadata object based on a dictionary
    func updateMetadata(on db: Database, _ block: @escaping () -> Metadata) -> EventLoopFuture<Void> {
        findMetadataReference(on: db).flatMap { metadata in
            metadata.use(block(), updateSlug: true)
            return metadata.update(on: db)
        }
    }

    /// publish a metadata object
    func publishMetadata(on db: Database) -> EventLoopFuture<Void> {
        findMetadataReference(on: db).flatMap { metadata in
            metadata.status = .published
            return metadata.update(on: db)
        }
    }
    
    /// publish a metadata object
    func publishAsHomePage(on db: Database) -> EventLoopFuture<Void> {
        findMetadataReference(on: db).flatMap { metadata in
            metadata.status = .published
            metadata.slug = ""
            return metadata.update(on: db)
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
