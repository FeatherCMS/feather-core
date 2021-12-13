//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

import Foundation

public struct SortingContext {

    public var key: String
    public var label: String?
    public var isDefault: Bool
    public var sort: FieldSort
    
    public init(key: String, label: String? = nil, isDefault: Bool = false, sort: FieldSort = .asc) {
        self.key = key
        self.label = label
        self.isDefault = isDefault
        self.sort = sort
    }
}
