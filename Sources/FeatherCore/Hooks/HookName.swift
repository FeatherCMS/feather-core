//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

import Vapor

public enum HookName {
    case name(String)
}

extension HookName: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .name(value)
    }
}

extension HookName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .name(let name):
            return name
        }
    }
}

public extension HookStorage {
    
    func register<ReturnType>(_ hook: HookName, use block: @escaping HookFunctionSignature<ReturnType>) {
        register(hook.description, use: block)
    }
    
    func register<ReturnType>(_ hook: HookName, use block: @escaping AsyncHookFunctionSignature<ReturnType>) {
        register(hook.description, use: block)
    }
}

public extension Request {

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
    
    func invoke<ReturnType>(_ hook: HookName, args: HookArguments = [:]) async -> ReturnType? {
        await invoke(hook.description, args: args)
    }

    func invokeAll<ReturnType>(_ hook: HookName, args: HookArguments = [:]) async -> [ReturnType] {
        await invokeAll(hook.description, args: args)
    }

    func invokeAllFlat<ReturnType>(_ hook: HookName, args: HookArguments = [:]) async -> [ReturnType] {
        let result: [[ReturnType]] = await invokeAll(hook.description, args: args)
        return result.flatMap { $0 }
    }
    
    func invokeAllFirst<ReturnType>(_ hook: HookName, args: HookArguments = [:]) async -> ReturnType? {
        let result: [ReturnType?] = await invokeAll(hook.description, args: args)
        return result.compactMap({ $0 }).first
    }
}

public extension Application {
    
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
    
    func invoke<ReturnType>(_ hook: HookName, args: HookArguments = [:]) async -> ReturnType? {
        await invoke(hook.description, args: args)
    }

    func invokeAll<ReturnType>(_ hook: HookName, args: HookArguments = [:]) async -> [ReturnType] {
        await invokeAll(hook.description, args: args)
    }
    
    func invokeAllFlat<ReturnType>(_ hook: HookName, args: HookArguments = [:]) async -> [ReturnType] {
        let result: [[ReturnType]] = await invokeAll(hook.description, args: args)
        return result.flatMap { $0 }
    }
    
    func invokeAllFirst<ReturnType>(_ hook: HookName, args: HookArguments = [:]) async -> ReturnType? {
        let result: [ReturnType?] = await invokeAll(hook.description, args: args)
        return result.compactMap({ $0 }).first
    }
}
