//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

public struct MultipleFileFieldContext {

    public var key: String
    public var label: LabelContext
    public var accept: String?
    public var error: String?
    
    public init(key: String,
                label: LabelContext? = nil,
                accept: String? = nil,
                error: String? = nil) {
        self.key = key
        self.label = label ?? .init(key: key)
        self.accept = accept
        self.error = error
    }
}
