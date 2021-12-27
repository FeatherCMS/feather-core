//
//  Application+Hooks.swift
//  VaporHooks
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//

public extension Application {

    private struct HookStorageKey: StorageKey {
        typealias Value = HookStorage
    }

    var hooks: HookStorage {
        get {
            if let existing = storage[HookStorageKey.self] {
                return existing
            }
            let new = HookStorage()
            storage[HookStorageKey.self] = new
            return new
        }
        set {
            storage[HookStorageKey.self] = newValue
        }
    }

    func invoke<ReturnType>(_ name: String, args: HookArguments = [:]) -> ReturnType? {
        let ctxArgs = args.merging(["app": self]) { (_, new) in new }
        return hooks.invoke(name, args: ctxArgs)
    }

    func invokeAll<ReturnType>(_ name: String, args: HookArguments = [:]) -> [ReturnType] {
        let ctxArgs = args.merging(["app": self]) { (_, new) in new }
        return hooks.invokeAll(name, args: ctxArgs)
    }

    func invokeAsync<ReturnType>(_ name: String, args: HookArguments = [:]) async throws -> ReturnType? {
        let ctxArgs = args.merging(["app": self]) { (_, new) in new }
        return try await hooks.invokeAsync(name, args: ctxArgs)
    }

    func invokeAllAsync<ReturnType>(_ name: String, args: HookArguments = [:]) async throws -> [ReturnType] {
        let ctxArgs = args.merging(["app": self]) { (_, new) in new }
        return try await hooks.invokeAllAsync(name, args: ctxArgs)
    }
}
