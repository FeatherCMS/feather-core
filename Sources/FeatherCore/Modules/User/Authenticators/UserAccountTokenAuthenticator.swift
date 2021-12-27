//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 19..
//

struct UserAccountTokenAuthenticator: AsyncBearerAuthenticator {

    func authenticate(bearer: BearerAuthorization, for req: Request) async throws {
        guard let token = try await UserTokenModel.query(on: req.db).filter(\.$value == bearer.token).first() else {
            return
        }
//        guard token.isValid else {
//            return try await token.delete(on: req.db)
//        }
        guard let user = try await UserAccountModel.findWithPermissionsBy(id: token.$user.id, on: req.db) else {
            return
        }
        req.auth.login(user.featherAccount)
    }
}
