//
//  HookStorage.swift
//  HookKit
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//

public final class HookStorage {

    var pointers: [HookFunctionPointer<HookFunction>]
    var asyncPointers: [HookFunctionPointer<AsyncHookFunction>]

    public init() {
        self.pointers = []
        self.asyncPointers = []
    }
}

