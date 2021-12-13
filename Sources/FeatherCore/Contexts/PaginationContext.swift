//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 28..
//

import Foundation

public struct PaginationContext: Codable {

    public let current: Int
    public let limit: Int
    public let total: Int
    
    public init(current: Int, limit: Int, total: Int) {
        self.current = current
        self.limit = limit
        self.total = total
    }
}

