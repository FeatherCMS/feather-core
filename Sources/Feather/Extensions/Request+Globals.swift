//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 15..
//

import Vapor

public extension Request {

    var globals: Globals {
        return .init(self)
    }

    struct Globals {
        let req: Request

        init(_ req: Request) {
            self.req = req
        }
    }
}

public extension Request.Globals {

    func get<T>(_ key: String, scope: String) -> T? {
        cache[scope + "." + key]
    }
    
    func has(_ key: String, scope: String) -> Bool {
        get(key, scope: scope) != nil
    }
    
    func set<T>(_ key: String, value: T, scope: String) {
        cache[scope + "." + key] = value
    }
    
    func unset(_ key: String, scope: String) {
        cache.unset(scope + "." + key)
    }
}


private extension Request.Globals {

    final class Cache {
        private var storage: [String: Any]

        init() {
            self.storage = [:]
        }

        subscript<T>(_ type: String) -> T? {
            get { storage[type] as? T }
            set { storage[type] = newValue }
        }
        
        func unset(_ key: String) {
            storage.removeValue(forKey: key)
        }
    }

    struct CacheKey: StorageKey {
        typealias Value = Cache
    }

    var cache: Cache {
        get {
            if let existing = req.storage[CacheKey.self] {
                return existing
            }
            let new = Cache()
            req.storage[CacheKey.self] = new
            return new
        }
        set {
            req.storage[CacheKey.self] = newValue
        }
    }
}


