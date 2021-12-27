//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

public extension SiblingsProperty {

    func reAttach(ids: [To.IDValue], on db: Database) async throws {
        let toDetach = (value ?? []).filter { !ids.contains($0._$id.value!) }
        let remainingIds = (value ?? []).map { $0._$id.value! }.filter { ids.contains($0) }
        let toAttach = ids.filter { !remainingIds.contains($0) }
        try await detach(toDetach, on: db)
        let items = try await To.query(on: db).filter(\To._$id ~~ toAttach).all()
        try await attach(items, on: db)
    }
}
