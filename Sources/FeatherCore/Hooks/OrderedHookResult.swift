//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//


public struct OrderedHookResult<T> {
    public let object: T
    public let order: Int

    public init(_ object: T, order: Int = 0) {
        self.object = object
        self.order = order
    }
}
