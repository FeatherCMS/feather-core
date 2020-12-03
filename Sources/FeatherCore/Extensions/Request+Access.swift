//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 03..
//

public extension Request {

    /// checks if the current user has access to a specific action, returns an ELF with a bool value
    func checkUserAccess(_ name: String) -> EventLoopFuture<Bool> {
        let accessIdentifier = "access"

        /// permission (access) components are separated by . character, so we have turn it to an access hook name
        let accessHook = name.replacingOccurrences(of: ".", with: "-") + "-" + accessIdentifier
        /// invoke name access hook if there is any
        let namedAccess: EventLoopFuture<Bool>? = invoke(accessHook)
        /// invoke generic access hook if there is any
        let genericAccess: EventLoopFuture<Bool>? = invoke(accessIdentifier, args: ["key": name])
        /// return the named access or the generic access or a fallback value (true)
        return namedAccess ?? genericAccess ?? eventLoop.future(true)
    }
}
