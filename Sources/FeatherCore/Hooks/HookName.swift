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
    
    func registerAsync<ReturnType>(_ hook: HookName, use block: @escaping AsyncHookFunctionSignature<ReturnType>) {
        registerAsync(hook.description, use: block)
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

