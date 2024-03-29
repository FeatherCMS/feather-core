//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 12..
//

public struct AnonymousAsyncHookFunction: AsyncHookFunction {

    private let functionBlock: AsyncHookFunctionSignature<Any>

    /// anonymous hooks can be initialized using a function block
    public init(_ functionBlock: @escaping AsyncHookFunctionSignature<Any>) {
        self.functionBlock = functionBlock
    }

    /// since they are hook functions they can be invoked with a given argument
    public func invokeAsync(_ args: HookArguments) async throws -> Any {
        try await functionBlock(args)
    }
}
