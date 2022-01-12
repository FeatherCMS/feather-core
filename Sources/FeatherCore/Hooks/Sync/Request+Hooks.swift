//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 12..
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
    
    func invokeAllOrdered<ReturnType>(_ hook: HookName, args: HookArguments = [:]) -> [ReturnType] {
        let result: [OrderedHookResult<ReturnType>] = invokeAllFlat(hook, args: args)
        return result.sorted { $0.order > $1.order }.map(\.object)
    }
   
}
