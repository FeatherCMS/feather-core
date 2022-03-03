//
//  HookStorage.swift
//  HookKit
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//

public final class HookStorage {

    fileprivate(set) var pointers: [HookFunctionPointer<HookFunction>]
    fileprivate(set) var asyncPointers: [HookFunctionPointer<AsyncHookFunction>]

    public init() {
        self.pointers = []
        self.asyncPointers = []
    }
    
    public func add(_ pointer: HookFunctionPointer<HookFunction>) {
        pointers.append(pointer)
        pointers.sort { $0.priority > $1.priority }
    }
    
    public func addAsync(_ pointer: HookFunctionPointer<AsyncHookFunction>) {
        asyncPointers.append(pointer)
        asyncPointers.sort { $0.priority > $1.priority }
    }
}

