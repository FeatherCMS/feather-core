//
//  ListPageInfo.swift
//  RequestProcessing
//
//  Created by Tibor Bodecs on 2021. 03. 26..
//

/// pagination metadata info
public struct Pagination: Codable {

    /// current page
    public let current: Int
    /// pagination limit (items per page)
    public let limit: Int
    /// total number of pages
    public let total: Int
    
    /// public init method
    public init(current: Int, limit: Int, total: Int) {
        self.current = current
        self.limit = limit
        self.total = total
    }
}

extension Pagination: Content {
    
}
