//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//

public extension SiblingsProperty {

    func reAttach(ids: [To.IDValue], on db: Database) -> EventLoopFuture<Void> {
        let toDetach = (value ?? []).filter { !ids.contains($0._$id.value!) }
        let remainingIds = (value ?? []).map { $0._$id.value! }.filter { ids.contains($0) }
        let toAttach = ids.filter { !remainingIds.contains($0) }

        return detach(toDetach, on: db).flatMap { [unowned self] Void -> EventLoopFuture<Void> in
            To.query(on: db)
                .filter(\To._$id ~~ toAttach)
                .all()
                .flatMap { [unowned self] items -> EventLoopFuture<Void>in
                    attach(items, on: db)
                }
        }
    }
}
