//
//  EventLoopFuture+Erase.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

public extension EventLoopFuture {

    /// erase an ELF result as Any
    func erase() -> EventLoopFuture<Any> { map { $0 as Any } }

    /// erase an ELF result as Any?
    func erase() -> EventLoopFuture<Any?> { map { $0 as Any? } }
}
