//
//  Request+Hooks.swift
//  VaporHooks
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//

public extension Request {

    func invoke<ReturnType>(_ name: String, args: HookArguments = [:]) -> ReturnType? {
        let ctxArgs = args.merging(["req": self]) { (_, new) in new }
        return application.invoke(name, args: ctxArgs)
    }

    func invokeAll<ReturnType>(_ name: String, args: HookArguments = [:]) -> [ReturnType] {
        let ctxArgs = args.merging(["req": self]) { (_, new) in new }
        return application.invokeAll(name, args: ctxArgs)
    }
    
    func invokeAsync<ReturnType>(_ name: String, args: HookArguments = [:]) async throws -> ReturnType? {
        let ctxArgs = args.merging(["req": self]) { (_, new) in new }
        return try await application.invokeAsync(name, args: ctxArgs)
    }

    func invokeAllAsync<ReturnType>(_ name: String, args: HookArguments = [:]) async throws -> [ReturnType] {
        let ctxArgs = args.merging(["req": self]) { (_, new) in new }
        return try await application.invokeAllAsync(name, args: ctxArgs)
    }
}
