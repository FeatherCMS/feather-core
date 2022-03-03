//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 25..
//

public extension Request {

    func getUserAccount() throws -> FeatherUser {
        guard let user = auth.get(FeatherUser.self) else {
            throw Abort(.forbidden)
        }
        return user
    }
}
