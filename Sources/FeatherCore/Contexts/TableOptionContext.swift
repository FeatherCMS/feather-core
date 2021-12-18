//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 18..
//

import Foundation

public struct TableOptionContext {
    public let allowedOrders: [String]
    public let defaultSort: FieldSort
    
    public init(allowedOrders: [String] = [], defaultSort: FieldSort = .asc) {
        self.allowedOrders = allowedOrders
        self.defaultSort = defaultSort
    }
}
