//
//  HookFunction.swift
//  HookKit
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//


/// a hook function is something that can be invoked with a given arguments
public protocol HookFunction {
    func invoke(_: HookArguments) -> Any
}


/// a hook function signature with a generic return type
public typealias HookFunctionSignature<T> = (HookArguments) -> T
