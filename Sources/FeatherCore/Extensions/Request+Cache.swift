//
//  Request+Cache.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 07..
//

public extension Request {

    var cache: Cache { .init(request: self) }

    struct Cache {
        let request: Request

        init(request: Request) {
            self.request = request
        }
    }
}

public extension Request.Cache {
    
    fileprivate final class KeyValueCache {
        fileprivate var storage: [String: Any?] = [:]
    }

    private struct CacheKey: StorageKey {
        typealias Value = KeyValueCache
    }

    fileprivate var keyValueCache: KeyValueCache {
        get {
            if let existing = request.storage[CacheKey.self] {
                return existing
            }
            let new = KeyValueCache()
            request.storage[CacheKey.self] = new
            return new
        }
        set {
            request.storage[CacheKey.self] = newValue
        }
    }

    // MARK: - public API
    
    subscript(index: String) -> Any? {
        get {
            keyValueCache.storage[index] ?? nil
        }
        set {
            keyValueCache.storage[index] = newValue
        }
    }

    //var storage: [String: Any?] { keyValueCache.storage }

    func exists(_ key: String) -> Bool {
        keyValueCache.storage[key] != nil
    }
}

public struct RequestCacheMiddleware: Middleware {
    
    public init() {}

    /// prepares the key-value cache storage
    ///     NOTE: return an event loop future with an array of key-values items to setup values
    public func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        let futures: [EventLoopFuture<[String: Any?]>] = req.invokeAll("prepare-request-cache")

        return req.eventLoop.flatten(futures)
            .map { $0.flatMap { $0 } }
            .flatMap { items in
                for item in items {
                    req.cache.keyValueCache.storage[item.key] = item.value
                }
                return next.respond(to: req)
            }
    }
}
