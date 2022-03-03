//
//  HookFunctionPointer.swift
//  HookKit
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//

public final class HookFunctionPointer<Pointer> {

    public var name: String
    public var pointer: Pointer
    public var returnType: Any.Type
    public var priority: Int
    
    public init(name: String,
                function: Pointer,
                returnType: Any.Type,
                priority: Int = 100) {
        self.name = name
        self.pointer = function
        self.returnType = returnType
        self.priority = priority
    }
}
