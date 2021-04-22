//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 22..
//

public extension HookStorage {
    
    func register<ReturnType>(_ hook: FeatherHook, use block: @escaping HookFunctionSignature<ReturnType>) {
        register(hook.description, use: block)
    }
}

public extension Request {

    func invoke<ReturnType>(_ hook: FeatherHook, args: HookArguments = [:]) -> ReturnType? {
        invoke(hook.description, args: args)
    }

    /// invokes all the available hook functions with a given name and inserts the app & req pointers as arguments
    func invokeAll<ReturnType>(_ hook: FeatherHook, args: HookArguments = [:]) -> [ReturnType] {
        invokeAll(hook.description, args: args)
    }
}

public extension Application {
    
    func invoke<ReturnType>(_ hook: FeatherHook, args: HookArguments = [:]) -> ReturnType? {
        invoke(hook.description, args: args)
    }

    /// invokes all the available hook functions with a given name and inserts the app pointer as argument
    func invokeAll<ReturnType>(_ hook: FeatherHook, args: HookArguments = [:]) -> [ReturnType] {
        invokeAll(hook.description, args: args)
    }
}

