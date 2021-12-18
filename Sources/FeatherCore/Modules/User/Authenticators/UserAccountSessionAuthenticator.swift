//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor
import Fluent

struct UserAccountSessionAuthenticator: AsyncSessionAuthenticator {
    typealias User = UserAccount

    func authenticate(sessionID: UUID, for req: Request) async throws {
        guard let model = try await UserAccountModel.findWithPermissionsBy(id: sessionID, on: req.db) else {
            return
        }
        req.auth.login(model.userAccount)
    }
}
