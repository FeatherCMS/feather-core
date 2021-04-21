//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//

public extension SiblingsProperty {
    
    func reAttach(ids: [To.IDValue], on db: Database) -> EventLoopFuture<Void> {
        detach(value ?? [], on: db).flatMap { [unowned self] Void -> EventLoopFuture<Void> in
            To.query(on: db)
                .filter(\To._$id ~~ ids)
                .all()
                .flatMap { [unowned self] items -> EventLoopFuture<Void>in
                    attach(items, on: db)
                }
        }
    }
}
