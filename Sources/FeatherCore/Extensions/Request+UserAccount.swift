//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 25..
//

public extension Request {

    func getUserAccount() throws -> FeatherAccount {
        guard let user = auth.get(FeatherAccount.self) else {
            throw Abort(.forbidden)
        }
        return user
    }
}
