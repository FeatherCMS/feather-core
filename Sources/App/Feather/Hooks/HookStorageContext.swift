//
//  HookStorage.swift
//  HookKit
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//

public final class HookStorage {

    private var pointers: [HookFunctionPointer<HookFunction>]
    private var asyncPointers: [HookFunctionPointer<AsyncHookFunction>]

    public init() {
        self.pointers = []
        self.asyncPointers = []
    }

    // MARK: - sync

    public func register<ReturnType>(_ name: String, use block: @escaping HookFunctionSignature<ReturnType>) {
        let function = AnonymousHookFunction { args -> Any in
            block(args)
        }
        let pointer = HookFunctionPointer<HookFunction>(name: name, function: function, returnType: ReturnType.self)
        pointers.append(pointer)
    }

    public func invoke<ReturnType>(_ name: String, args: HookArguments = [:]) -> ReturnType? {
        pointers.first { $0.name == name && $0.returnType == ReturnType.self }?.pointer.invoke(args) as? ReturnType
    }
 
    public func invokeAll<ReturnType>(_ name: String, args: HookArguments = [:]) -> [ReturnType] {
        let fn = pointers.filter { $0.name == name && $0.returnType == ReturnType.self }
        return fn.compactMap { $0.pointer.invoke(args) as? ReturnType }
    }
    
    // MARK: - async
    
    public func register<ReturnType>(_ name: String, use block: @escaping AsyncHookFunctionSignature<ReturnType>) {
        let function = AnonymousAsyncHookFunction { args -> Any in
            await block(args)
        }
        let pointer = HookFunctionPointer<AsyncHookFunction>(name: name, function: function, returnType: ReturnType.self)
        asyncPointers.append(pointer)
    }
    
    public func invoke<ReturnType>(_ name: String, args: HookArguments = [:]) async -> ReturnType? {
        await asyncPointers.first { $0.name == name && $0.returnType == ReturnType.self }?.pointer.invoke(args) as? ReturnType
    }

    public func invokeAll<ReturnType>(_ name: String, args: HookArguments = [:]) async -> [ReturnType] {
        let fn = asyncPointers.filter { $0.name == name && $0.returnType == ReturnType.self }
        return await fn.asyncCompactMap { await $0.pointer.invoke(args) as? ReturnType }
    }
}

