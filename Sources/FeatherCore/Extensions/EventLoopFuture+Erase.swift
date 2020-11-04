//
//  EventLoopFuture+Erase.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

public extension EventLoopFuture {

    func erase() -> EventLoopFuture<Any> {
        self.map { $0 as Any }
    }

    func erase() -> EventLoopFuture<Any?> {
        self.map { $0 as Any? }
    }
}
