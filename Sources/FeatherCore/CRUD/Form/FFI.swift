//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

import Foundation


public protocol FormFieldInput {
    func process(req: Request)
}

public final class GenericFormFieldInput<T: Decodable>: FormFieldInput {

    public var key: String
    public var value: T?
    
    public init(key: String, value: T? = nil) {
        self.key = key
        self.value = value
    }

    public func process(req: Request) {
        value = try? req.content.get(T.self, at: key)
    }
}




