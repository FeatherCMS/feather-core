//
//  Request+Variables.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 17..
//

public extension Request {

    /// return a value of an existing system variable
    func variable(_ key: String) -> EventLoopFuture<String?> {
        let result: EventLoopFuture<String?>? = invoke("variable-get", args: ["key": key])
        return result ?? eventLoop.future(nil)
    }

    /// set the value of an existing system variable
    func setVariable(_ key: String, value: String?) -> EventLoopFuture<Void> {
        let result: EventLoopFuture<Void>? = invoke("variable-set", args: ["key": key, "value": value as Any])
        return result ?? eventLoop.future()
    }
}
