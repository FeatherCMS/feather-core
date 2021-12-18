//
//  AnonymousHookFunction.swift
//  HookKit
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//

/// anonymous hook function
public struct AnonymousHookFunction: HookFunction {

    private let functionBlock: HookFunctionSignature<Any>

    /// anonymous hooks can be initialized using a function block
    public init(_ functionBlock: @escaping HookFunctionSignature<Any>) {
        self.functionBlock = functionBlock
    }

    /// since they are hook functions they can be invoked with a given argument
    public func invoke(_ args: HookArguments) -> Any {
        functionBlock(args)
    }
}

public struct AnonymousAsyncHookFunction: AsyncHookFunction {

    private let functionBlock: AsyncHookFunctionSignature<Any>

    /// anonymous hooks can be initialized using a function block
    public init(_ functionBlock: @escaping AsyncHookFunctionSignature<Any>) {
        self.functionBlock = functionBlock
    }

    /// since they are hook functions they can be invoked with a given argument
    public func invoke(_ args: HookArguments) async throws -> Any {
        try await functionBlock(args)
    }
}
