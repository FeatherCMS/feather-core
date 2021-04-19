//
//  UserModelSessionAuthenticator.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 06. 01..
//

struct SystemUserSessionAuthenticator: SessionAuthenticator {
    
    typealias User = FeatherCore.User

    func authenticate(sessionID: User.SessionID, for req: Request) -> EventLoopFuture<Void> {
        SystemUserModel.findWithPermissionsBy(id: sessionID, on: req.db).map { user  in
            if let user = user {
                req.auth.login(user.authUserValue)
            }
        }
    }
}
