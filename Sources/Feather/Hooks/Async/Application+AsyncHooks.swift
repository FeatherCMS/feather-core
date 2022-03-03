//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 12..
//

public extension Application {

    func invokeAsync<ReturnType>(_ name: String, args: HookArguments = [:]) async throws -> ReturnType? {
        let ctxArgs = args.merging(["app": self]) { (_, new) in new }
        return try await hooks.invokeAsync(name, args: ctxArgs)
    }

    func invokeAllAsync<ReturnType>(_ name: String, args: HookArguments = [:]) async throws -> [ReturnType] {
        let ctxArgs = args.merging(["app": self]) { (_, new) in new }
        return try await hooks.invokeAllAsync(name, args: ctxArgs)
    }
    
    // MARK: - named
    
    func invokeAsync<ReturnType>(_ hook: HookName, args: HookArguments = [:]) async throws -> ReturnType? {
        try await invokeAsync(hook.description, args: args)
    }

    func invokeAllAsync<ReturnType>(_ hook: HookName, args: HookArguments = [:]) async throws -> [ReturnType] {
        try await invokeAllAsync(hook.description, args: args)
    }
    
    func invokeAllFlatAsync<ReturnType>(_ hook: HookName, args: HookArguments = [:]) async throws -> [ReturnType] {
        let result: [[ReturnType]] = try await invokeAllAsync(hook.description, args: args)
        return result.flatMap { $0 }
    }
    
    func invokeAllFirstAsync<ReturnType>(_ hook: HookName, args: HookArguments = [:]) async throws -> ReturnType? {
        let result: [ReturnType?] = try await invokeAllAsync(hook.description, args: args)
        return result.compactMap({ $0 }).first
    }
}
