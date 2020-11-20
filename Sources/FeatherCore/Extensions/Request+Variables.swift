//
//  Request+Variables.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

/// global request variables middleware it makes possible to store key-value pairs in a db table
public struct RequestVariablesMiddleware: Middleware {
    
    public init() {}

    /// the variables are prepared via this middleware, so they can be accessed later on in a "synchronous" way
    public func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        req.application.viper.invokeHook(name: "prepare-variables", req: req, type: [String: String].self)
        .flatMap { items in
            for variable in items ?? [:] {
                req.variables.cache.storage[variable.key] = variable.value
            }
            return next.respond(to: req)
        }
    }
}

public extension Request {

    /// system variables
    var variables: Variables {
        return .init(request: self)
    }

    struct Variables {
        let request: Request

        init(request: Request) {
            self.request = request
        }
    }
}

public extension Request.Variables {
    
    private struct CacheKey: StorageKey {
        typealias Value = Cache
    }

    fileprivate var cache: Cache {
        get {
            if let existing = request.storage[CacheKey.self] {
                return existing
            }
            let new = Cache()
            request.storage[CacheKey.self] = new
            return new
        }
        set {
            request.storage[CacheKey.self] = newValue
        }
    }

    fileprivate final class Cache {
        fileprivate var storage: [String: String] = [:]
    }
    
    /// returns all system variables
    var all: [String: String] {
        cache.storage
    }

    /// get a system variable based on a key
    func get(_ key: String) -> String? {
        cache.storage[key]
    }

    /// checks if a variable exists
    func has(_ key: String) -> Bool {
        cache.storage[key] != nil
    }

    /// sets a new variable, it's an async operation so it returns an ELF object
    func set(_ key: String, value: String, hidden: Bool? = nil, notes: String? = nil) -> EventLoopFuture<Void> {
        request.application.viper.invokeHook(name: "set-variable",
                                                  req: request,
                                                  type: Bool.self,
                                                  params: ["key": key,
                                                           "value": value,
                                                           "hidden": hidden as Any,
                                                           "notes": notes as Any])

            .map { result in
                if let success = result, success {
                    cache.storage[key] = value
                }
            }
    }

    /// removes a variable with a given key, it's an async operation, ELF returned
    func unset(_ key: String) -> EventLoopFuture<Void> {
        request.application.viper.invokeHook(name: "unset-variable",
                                                  req: request,
                                                  type: Bool.self,
                                                  params: ["key": key])
            .map { result in
                if let success = result, success {
                    cache.storage[key] = nil
                }
            }
    }
}

