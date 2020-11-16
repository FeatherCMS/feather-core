//
//  Metadata+Viper.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

public extension ViperModel where Self.IDValue == UUID {
    
    /// joins the metadata object on the ViperModel query, if a path is present it'll use it as a filter to return only one instance that matches the slug
    static func findMetadata(on db: Database, path: String? = nil) -> QueryBuilder<Self> {
        let query = Self.query(on: db)
            .join(Metadata.self, on: \Metadata.$reference == \Self._$id)
            .filter(Metadata.self, \.$module == Module.name)
            .filter(Metadata.self, \.$model == name)

        
        if let path = path {
            return query.filter(Metadata.self, \.$slug == path.trimmingSlashes())
        }
        return query
    }
    
    /// request the associated metadata object, if there is none the future will return a .notFound error
    func fetchMetadata(on db: Database) -> EventLoopFuture<Metadata> {
        Metadata.query(on: db)
            .filter(\.$reference == id!)
            .filter(\.$module == Self.Module.name)
            .filter(\.$model == Self.name)
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    /// update a metadata object with a given set of properties using a block, can be used to patch metadata objects in the db
    func updateMetadata(on db: Database, _ block: @escaping (Metadata) -> Void) -> EventLoopFuture<Void> {
        fetchMetadata(on: db).flatMap { metadata in
            block(metadata)
            return metadata.update(on: db)
        }
    }
    
    /// publish a metadata object
    func publishMetadata(on db: Database) -> EventLoopFuture<Void> {
        updateMetadata(on: db) { $0.status = .published }
    }
}
