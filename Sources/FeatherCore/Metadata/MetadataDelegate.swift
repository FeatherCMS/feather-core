//
//  MetadataDelegate.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 17..
//

/// metadata delegate protocol
public protocol MetadataDelegate {

    /// query builder
    func join<T: MetadataModel>(queryBuilder: QueryBuilder<T>) -> QueryBuilder<T>
    func filter<T: MetadataModel>(queryBuilder: QueryBuilder<T>, path: String) -> QueryBuilder<T>
    func filter<T: MetadataModel>(queryBuilder: QueryBuilder<T>, before: Date) -> QueryBuilder<T>
    func filterVisible<T: MetadataModel>(queryBuilder: QueryBuilder<T>) -> QueryBuilder<T>
    func filter<T: MetadataModel>(queryBuilder: QueryBuilder<T>, status: Metadata.Status) -> QueryBuilder<T>
    func sortByDate<T: MetadataModel>(queryBuilder: QueryBuilder<T>, direction: DatabaseQuery.Sort.Direction) -> QueryBuilder<T>
    
    /// viper model
    func joinedMetadata<T: MetadataModel>(_ model: T) -> Metadata?
    func find<T: MetadataModel>(_ model: T.Type, reference: UUID, on db: Database) -> EventLoopFuture<Metadata?>
    
    func create(_ metadata: Metadata, on db: Database) -> EventLoopFuture<Void>
    func update(_ metadata: Metadata, on db: Database) -> EventLoopFuture<Void>
    func delete(_ metadata: Metadata, on db: Database) -> EventLoopFuture<Void>
    
}
