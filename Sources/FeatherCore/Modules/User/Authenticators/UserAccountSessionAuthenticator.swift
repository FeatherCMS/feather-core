//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

struct UserAccountSessionAuthenticator: AsyncSessionAuthenticator {
    typealias User = FeatherAccount

    func authenticate(sessionID: UUID, for req: Request) async throws {
        guard let model = try await UserAccountModel.findWithPermissionsBy(id: sessionID, on: req.db) else {
            return
        }
        return req.auth.login(model.featherAccount)
    }
}
