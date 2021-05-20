//
//  Request+Processing.swift
//  RequestProcessing
//
//  Created by Tibor Bodecs on 2021. 03. 19..
//

extension Request {
    
    var processing: RequestProcessing {
        get { .init(request: self) }
        set {}
    }
}

struct RequestProcessing {
    
    // MARK: - internal init
    
    let request: Request
    
    init(request: Request) {
        self.request = request
    }
    
    // MARK: - context storage
    
    private struct ContextStorageKey: StorageKey {
        typealias Value = [String: Any]
    }
    
    var context: [String: Any] {
        get {
            if let existing = request.storage[ContextStorageKey.self] {
                return existing
            }
            let new: [String: Any] = [:]
            request.storage[ContextStorageKey.self] = new
            return new
        }
        set {
            request.storage[ContextStorageKey.self] = newValue
        }
    }
}
