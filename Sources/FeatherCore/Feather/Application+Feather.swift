//
//  Application+Viper.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 23..
//

public extension Application {

    private struct FeatherKey: StorageKey {
        typealias Value = Feather
    }

    /// storage for the viper component
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
