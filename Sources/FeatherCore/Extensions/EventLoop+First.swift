//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//

public extension EventLoop {

    func first<T>(_ futures: [EventLoopFuture<T?>]) -> EventLoopFuture<T?> {
        let initial: EventLoopFuture<T?> = future(nil)
        let folded = initial.fold(futures) { [self] response, value -> EventLoopFuture<T?> in
            if let newResponse = value {
                return future(newResponse)
            }
            return future(response)
        }
        return folded
    }
}
