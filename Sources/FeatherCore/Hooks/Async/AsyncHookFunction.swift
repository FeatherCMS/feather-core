//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 12..
//

import Foundation

public protocol AsyncHookFunction {
    func invokeAsync(_: HookArguments) async throws -> Any
}


public typealias AsyncHookFunctionSignature<T> = (HookArguments) async throws -> T
