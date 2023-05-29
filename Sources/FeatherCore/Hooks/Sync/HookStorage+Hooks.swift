//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 12..
//

public extension HookStorage {

    func register<ReturnType>(_ name: String,
                              use block: @escaping HookFunctionSignature<ReturnType>,
                              priority: Int = 100) {
        let function = AnonymousHookFunction { args -> Any in
            block(args)
        }
        let pointer = HookFunctionPointer<HookFunction>(name: name,
                                                        function: function,
                                                        returnType: ReturnType.self,
                                                        priority: priority)
        add(pointer)
    }
    
    func register<ReturnType>(_ hook: HookName,
                              use block: @escaping HookFunctionSignature<ReturnType>,
                              priority: Int = 100) {
        register(hook.description, use: block, priority: priority)
    }

    // MARK: - invocation

    func invoke<ReturnType>(_ name: String, args: HookArguments = [:]) -> ReturnType? {
        pointers.first { $0.name == name && $0.returnType == ReturnType.self }?.pointer.invoke(args) as? ReturnType
    }
 
    func invokeAll<ReturnType>(_ name: String, args: HookArguments = [:]) -> [ReturnType] {
        let fn = pointers.filter { $0.name == name && $0.returnType == ReturnType.self }
        return fn.compactMap { $0.pointer.invoke(args) as? ReturnType }
    }
}

