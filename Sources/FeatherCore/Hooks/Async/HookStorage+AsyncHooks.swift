//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 12..
//

public extension HookStorage {
    
    func registerAsync<ReturnType>(_ name: String, use block: @escaping AsyncHookFunctionSignature<ReturnType>) {
        let function = AnonymousAsyncHookFunction { args -> Any in
            try await block(args)
        }
        let pointer = HookFunctionPointer<AsyncHookFunction>(name: name, function: function, returnType: ReturnType.self)
        asyncPointers.append(pointer)
    }

    func invokeAsync<ReturnType>(_ name: String, args: HookArguments = [:]) async throws -> ReturnType? {
        try await asyncPointers.first { $0.name == name && $0.returnType == ReturnType.self }?.pointer.invokeAsync(args) as? ReturnType
    }

    func invokeAllAsync<ReturnType>(_ name: String, args: HookArguments = [:]) async throws -> [ReturnType] {
        let fn = asyncPointers.filter { $0.name == name && $0.returnType == ReturnType.self }
        return try await fn.compactMapAsync { try await $0.pointer.invokeAsync(args) as? ReturnType }
    }
    
    // MARK: - named
    
    func registerAsync<ReturnType>(_ hook: HookName, use block: @escaping AsyncHookFunctionSignature<ReturnType>) {
        registerAsync(hook.description, use: block)
    }
}

