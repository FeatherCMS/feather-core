//
//  AccessLoader.swift
//  RequestProcessing
//
//  Created by Tibor Bodecs on 2021. 03. 26..
//

public struct AccessLoader {

    public init() {}

    public func checkAccess(req: Request, for permissions: [Permission]) -> EventLoopFuture<[String: Bool]> {
        let futures = permissions.map { permission in req.checkAccess(for: permission).map { value -> (Permission, Bool) in (permission, value) } }
        let result: EventLoopFuture<[String: Bool]> = req.eventLoop.future([:])
        return result.fold(futures) { result, access -> EventLoopFuture<[String : Bool]> in
            var newResult = result
            newResult[access.0.identifier] = access.1
            return req.eventLoop.future(newResult)
        }
    }
}
