//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 03. 26..
//

//public final class PaginationContainer<T>: Codable where T: Codable {
//
//    /// paged generic encodable items
//    public let items: [T]
//
//    /// additional page information
//    public let info: Pagination
//
//    /// generic init method
//    public init(_ items: [T], info: Pagination) {
//        self.items = items
//        self.info = info
//    }
//
//    /// NOTE: we can only nest metadata if we init a new object...
//    public func map<U>(_ transform: (T) throws -> (U)) rethrows -> PaginationContainer<U> where U: Codable {
//        try .init(items.map(transform), info: info)
//    }
//}
//


/// a custom paged list with metadata information
public struct PaginationContainer<T>: Encodable where T: Encodable {

    /// paged generic encodable items
    public let items: [T]

    /// additional page information
    public let info: Pagination

    /// generic init method
    public init(_ items: [T], info: Pagination) {
        self.items = items
        self.info = info
    }

    /// NOTE: we can only nest metadata if we init a new object...
    public func map<U>(_ transform: (T) throws -> (U)) rethrows -> PaginationContainer<U> where U: Encodable {
        try .init(items.map(transform), info: info)
    }
}

