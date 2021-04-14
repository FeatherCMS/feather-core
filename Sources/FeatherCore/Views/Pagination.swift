//
//  ListPageInfo.swift
//  RequestProcessing
//
//  Created by Tibor Bodecs on 2021. 03. 26..
//

//public final class Pagination: Codable {
//
//    public let current: Int
//    public let limit: Int
//    public let total: Int
//
//    public init(current: Int = 0, limit: Int = 10, total: Int = 0) {
//        self.current = current
//        self.limit = limit
//        self.total = total
//    }
//}

/// pagination metadata info
public struct Pagination: TemplateDataRepresentable {

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
    
    public var templateData: TemplateData {
        .dictionary([
            "current": .int(current),
            "limit": .int(limit),
            "total": .int(total),
        ])
    }
}
