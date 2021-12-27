//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

public struct MultifileFieldContext {

    public var key: String
    public var label: LabelContext
    public var error: String?
    
    public init(key: String, label: LabelContext? = nil, error: String? = nil) {
        self.key = key
        self.label = label ?? .init(key: key)
        self.error = error
    }
}
