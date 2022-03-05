//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

import Fluent

extension QueryBuilder {

    func paginate(limit: Int, page: Int) async throws -> ListContainer<Model> {
        let start = (page - 1) * limit
        let end = page * limit
        let total = try await count()
        let items = try await copy().range(start..<end).all()
        let totalPages = Int(ceil(Float(total) / Float(limit)))
        return ListContainer(items, info: .init(current: page, limit: limit, total: totalPages))
    }
}
