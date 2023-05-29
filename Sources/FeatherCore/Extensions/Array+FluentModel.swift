//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 18..
//

import Fluent

public extension Array where Element: FluentKit.Model {

    /// chunks an array into smaller pieces
    private func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
    
    /// create an array of database models using chunks to avoid huge SQL queries...
    func create(on database: Database, chunks: Int) async throws {
        guard !self.isEmpty else {
            return
        }
        let elements = chunked(into: chunks)
        try await elements.forEachAsync { chunk in
            try await chunk.create(on: database)
        }
    }
}
