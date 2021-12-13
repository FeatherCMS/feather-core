//
//  HookFunction.swift
//  HookKit
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//

/// just an alias for a key-value-based arguments
public typealias HookArguments = [String: Any]

/// a hook function is something that can be invoked with a given arguments
public protocol HookFunction {
    func invoke(_: HookArguments) -> Any
}

public protocol AsyncHookFunction {
    func invoke(_: HookArguments) async -> Any
}

/// a hook function signature with a generic return type
public typealias HookFunctionSignature<T> = (HookArguments) -> T

public typealias AsyncHookFunctionSignature<T> = (HookArguments) async -> T







