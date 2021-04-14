//
//  UserModelSessionAuthenticator.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 06. 01..
//

struct SystemUserSessionAuthenticator: SessionAuthenticator {
    
    typealias User = SystemUserModel

    func authenticate(sessionID: User.SessionID, for req: Request) -> EventLoopFuture<Void> {
        User.findWithPermissionsBy(id: sessionID, on: req.db).map { user  in
            if let user = user {
                req.auth.login(user)
            }
        }
    }
}
