//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

public struct SortingContext {

    public var key: String
    public var label: String?
    public var isDefault: Bool
    public var defaultSort: FieldSort
    
    public init(key: String, label: String? = nil, isDefault: Bool = false, defaultSort: FieldSort = .asc) {
        self.key = key
        self.label = label
        self.isDefault = isDefault
        self.defaultSort = defaultSort
    }
}
