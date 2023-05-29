//
//  Application+Hooks.swift
//  VaporHooks
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//

import Vapor

public extension Application {

    private struct HookStorageKey: StorageKey {
        typealias Value = HookStorage
    }

    var hooks: HookStorage {
        get {
            if let existing = storage[HookStorageKey.self] {
                return existing
            }
            let new = HookStorage()
            storage[HookStorageKey.self] = new
            return new
        }
        set {
            storage[HookStorageKey.self] = newValue
        }
    }

   
}
