//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 26..
//

import Foundation

public extension Sequence {
    
    func forEachAsync(_ transform: (Element) async throws -> Void) async rethrows {
        for element in self {
            try await transform(element)
        }
    }

    func mapAsync<T>(_ transform: (Element) async throws -> T) async rethrows -> [T] {
        var values = [T]()
        for element in self {
            try await values.append(transform(element))
        }
        return values
    }
    
    func compactMapAsync<T>(_ transform: (Element) async throws -> T?) async rethrows -> [T] {
        var values = [T]()
        for element in self {
            guard let value = try await transform(element) else {
                continue
            }
            values.append(value)
        }
        return values
    }
}
