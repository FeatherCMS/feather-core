//
//  Metadata+Viper.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

public extension ViperModel where Self.IDValue == UUID {
    
    static func findMetadata(on db: Database, path: String? = nil) -> QueryBuilder<Self> {
        let query = Self.query(on: db)
            .join(Metadata.self, on: \Metadata.$reference == \Self._$id)
            .filter(Metadata.self, \.$module == Module.name)
            .filter(Metadata.self, \.$model == name)

        if let path = path {
            return query.filter(Metadata.self, \.$slug == path.safeSlug())
        }
        return query
    }
    
    func metadata(on db: Database) throws -> EventLoopFuture<Metadata> {
        Metadata.query(on: db)
            .filter(\.$reference == id!)
            .filter(\.$module == Self.Module.name)
            .filter(\.$model == Self.name)
            .first()
            .unwrap(or: Abort(.notFound))
    }

    func updateMetadata(on db: Database, _ block: @escaping (Metadata) -> Void) throws -> EventLoopFuture<Void> {
        try metadata(on: db).flatMap { metadata in
            block(metadata)
            return metadata.update(on: db)
        }
    }
    
    func publish(slug: String? = nil, on db: Database) throws -> EventLoopFuture<Void> {
        try updateMetadata(on: db) { metadata in
            metadata.status = .published
            if let slug = slug {
                metadata.slug = slug
            }
        }
    }
}
