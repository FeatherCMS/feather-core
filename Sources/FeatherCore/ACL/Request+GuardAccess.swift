//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 10..
//

public extension RoutesBuilder {

    func guardAccess(for permission: Permission) -> RoutesBuilder {
        grouped(AccessGuardMiddleware(permission))
    }
}
