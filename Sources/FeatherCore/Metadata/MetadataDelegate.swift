//
//  MetadataDelegate.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 17..
//

/// metadata delegate protocol
public protocol MetadataDeletgate {

    /// query builder
    func join<T: MetadataModel>(queryBuilder: QueryBuilder<T>) -> QueryBuilder<T>
    func filter<T: MetadataModel>(queryBuilder: QueryBuilder<T>, path: String) -> QueryBuilder<T>
    func filter<T: MetadataModel>(queryBuilder: QueryBuilder<T>, before: Date) -> QueryBuilder<T>
    func filter<T: MetadataModel>(queryBuilder: QueryBuilder<T>, status: Metadata.Status) -> QueryBuilder<T>
    func sortByDate<T: MetadataModel>(queryBuilder: QueryBuilder<T>, direction: DatabaseQuery.Sort.Direction) -> QueryBuilder<T>
    
    /// viper model
    var joinedMetadata: Metadata? { get }
    func find(id: UUID, on db: Database) -> EventLoopFuture<Metadata?>
    func update(_ metadata: Metadata, on db: Database) -> EventLoopFuture<Void>
    
}
