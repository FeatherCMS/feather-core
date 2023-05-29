//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

import Vapor

public extension Application {

    private struct FeatherKey: StorageKey {
        typealias Value = Feather
    }

    var feather: Feather {
        get {
            if let existing = storage[FeatherKey.self] {
                return existing
            }
            let new = Feather(app: self)
            storage[FeatherKey.self] = new
            return new
        }
        set {
            storage[FeatherKey.self] = newValue
        }
    }
}
