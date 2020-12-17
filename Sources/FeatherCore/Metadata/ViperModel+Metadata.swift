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
        let hookFilters: [String]? = req.invoke("metadata-filters", args: [
            "module": Module.name,
            "model": Self.name,
            "reference": id!,
        ])
        let filters = hookFilters ?? []
        
        /// if the user explicitly disabled filters we can return the content
        if filters.contains("[disable-all-filters]") {
            return content
        }

        let result: [[ContentFilter]] = req.invokeAll("content-filters")

        /// we use the default filters if there was no selected filter for the metadata
        var activeFilters: [String] = []
        if
            activeFilters.isEmpty,
            let variables = req.cache["system.variables"] as? [String:Any],
            let defaultFilters = variables["frontend.site.filters"] as? String
        {
            activeFilters = defaultFilters.split(separator: ",").map { String($0) }
        }
        else {
            activeFilters = filters
        }
        return result
            .flatMap { $0 }
            .filter { activeFilters.contains($0.key) }
            .reduce(content) { $1.filter($0) }
    }

    // MARK: - find metadata info

    static func findMetadataBy(id: UUID, req: Request) -> EventLoopFuture<Metadata?> {
        let res: EventLoopFuture<Metadata?>? = req.invoke("metadata-find", args: [
            "module": Module.name,
            "model": Self.name,
            "id": id,
        ])
        return res ?? req.eventLoop.future(nil)
    }

    // MARK: - joined metadata api
    
    /// returns the joined metadata model as a dictionary or an empty dictionary
    func joinedMetadata(req: Request) -> Metadata? {
        let res: Metadata? = req.invoke("metadata-join", args: ["object": self])
        return res
    }

    /// joins the metadata object on the ViperModel query, if a path is present it'll use it as a filter to return only one instance that matches the slug
    static func queryPublicMetadata(req: Request) -> QueryBuilder<Self> {
        query(on: req.db).joinPublicMetadata(req: req)
    }

    /// find an object with an associated the metadata object for a given path
    static func queryPublicMetadata(path: String, req: Request) -> QueryBuilder<Self> {
        queryPublicMetadata(req: req).filterMetadata(path: path, req: req)
    }
    
    // MARK: - update associated metadata

    /// update metadata
    func updateMetadata(req: Request, _ block: @escaping () -> Metadata) -> EventLoopFuture<Void> {
        let res: EventLoopFuture<Void>? = req.invoke("metadata-update", args: [
            "metadata": block(),
            "reference": id!,
            "module": Module.name,
            "model": Self.name,
        ])
        return res ?? req.eventLoop.future()
    }
}

public extension ViperModel where Self: MetadataRepresentable, Self: LeafDataRepresentable {

    /// returns the default leaf data object coinaining the metadata leaf data (metadata info must be already joined / present)
    func leafDataWithJoinedMetadata(req: Request) -> LeafData {
        var data: [String: LeafData] = leafData.dictionary!
        data["metadata"] = joinedMetadata(req: req)?.leafData ?? .dictionary(nil)
        return .dictionary(data)
    }
}
