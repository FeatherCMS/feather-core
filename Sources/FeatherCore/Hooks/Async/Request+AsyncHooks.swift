//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 12..
//

public extension Request {

    func invokeAsync<ReturnType>(_ name: String, args: HookArguments = [:]) async throws -> ReturnType? {
        let ctxArgs = args.merging(["req": self]) { (_, new) in new }
        return try await application.invokeAsync(name, args: ctxArgs)
    }

    func invokeAllAsync<ReturnType>(_ name: String, args: HookArguments = [:]) async throws -> [ReturnType] {
        let ctxArgs = args.merging(["req": self]) { (_, new) in new }
        return try await application.invokeAllAsync(name, args: ctxArgs)
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
    
    func invokeAllOrderedAsync<ReturnType>(_ hook: HookName, args: HookArguments = [:]) async throws -> [ReturnType] {
        let result: [OrderedHookResult<ReturnType>] = try await invokeAllFlatAsync(hook, args: args)
        return result.sorted { $0.order > $1.order }.map(\.object)
    }
    
    func invokeAllFirstAsync<ReturnType>(_ hook: HookName, args: HookArguments = [:]) async throws -> ReturnType? {
        let result: [ReturnType?] = try await invokeAllAsync(hook.description, args: args)
        return result.compactMap({ $0 }).first
    }
}
