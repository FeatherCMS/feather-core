//
//  UserModelSessionAuthenticator.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 06. 01..
//

struct UserAccountSessionAuthenticator: SessionAuthenticator {
    
    typealias User = FeatherCore.User

    func authenticate(sessionID: User.SessionID, for req: Request) -> EventLoopFuture<Void> {
        UserAccountModel.findWithPermissionsBy(id: sessionID, on: req.db).map { user  in
            if let user = user {
                req.auth.login(user.aclObject)
            }
        }
    }
}
