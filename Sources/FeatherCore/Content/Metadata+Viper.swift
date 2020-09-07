//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

public extension ViperModel where Self.IDValue == UUID {
    
    static func findMetadata(on db: Database, path: String? = nil) -> QueryBuilder<Self> {
        let query = self.query(on: db)
        .join(Metadata.self, on: \Metadata.$reference == \Self._$id)
        .filter(Metadata.self, \.$module == self.Module.name)
        .filter(Metadata.self, \.$model == self.name)
        //.filter(Metadata.self, \.$status != .archived)

        if let path = path {
            return query.filter(Metadata.self, \.$slug == path.safeSlug())
        }
        return query
    }
    
    func metadata(on db: Database) throws -> EventLoopFuture<Metadata> {
        Metadata.query(on: db)
            .filter(\.$reference == self.id!)
            .filter(\.$module == Self.Module.name)
            .filter(\.$model == Self.name)
            .first()
            .unwrap(or: Abort(.notFound))
    }

    func updateMetadata(on db: Database, _ block: @escaping (Metadata) -> Void) throws -> EventLoopFuture<Void> {
        try self.metadata(on: db)
        .flatMap { metadata in
            block(metadata)
            return metadata.update(on: db)
        }
    }
    
    func publish(slug: String? = nil, on db: Database) throws -> EventLoopFuture<Void> {
        try self.updateMetadata(on: db) { metadata in
            metadata.status = .published
            if let slug = slug {
                metadata.slug = slug
            }
        }
    }
}
