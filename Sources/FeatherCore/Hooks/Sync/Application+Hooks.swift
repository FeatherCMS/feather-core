//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 12..
//

public extension Application {
    
    func invoke<ReturnType>(_ name: String, args: HookArguments = [:]) -> ReturnType? {
        let ctxArgs = args.merging(["app": self]) { (_, new) in new }
        return hooks.invoke(name, args: ctxArgs)
    }

    func invokeAll<ReturnType>(_ name: String, args: HookArguments = [:]) -> [ReturnType] {
        let ctxArgs = args.merging(["app": self]) { (_, new) in new }
        return hooks.invokeAll(name, args: ctxArgs)
    }

    // MARK: - named
    
    func invoke<ReturnType>(_ hook: HookName, args: HookArguments = [:]) -> ReturnType? {
        invoke(hook.description, args: args)
    }

    func invokeAll<ReturnType>(_ hook: HookName, args: HookArguments = [:]) -> [ReturnType] {
        invokeAll(hook.description, args: args)
    }
    
    func invokeAllFirst<ReturnType>(_ hook: HookName, args: HookArguments = [:]) -> ReturnType? {
        let result: [ReturnType?] = invokeAll(hook.description, args: args)
        return result.compactMap({ $0 }).first
    }
    
    func invokeAllFlat<ReturnType>(_ hook: HookName, args: HookArguments = [:]) -> [ReturnType] {
        let result: [[ReturnType]] = invokeAll(hook.description, args: args)
        return result.flatMap { $0 }
    }
}
