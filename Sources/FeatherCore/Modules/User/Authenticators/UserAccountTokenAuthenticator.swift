//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 10..
//

struct UserAccountTokenAuthenticator: BearerAuthenticator {
    
    typealias User = FeatherCore.User
    
    func authenticate(bearer: BearerAuthorization, for req: Request) -> EventLoopFuture<Void> {
        UserTokenModel.query(on: req.db).filter(\.$value == bearer.token).first().flatMap { token in
            guard let token = token else {
                return req.eventLoop.future()
            }
            return UserAccountModel.findWithRolesBy(id: token.$user.id, on: req.db).map { user in
                guard let user = user else {
                    return
                }
                req.auth.login(user.aclObject)
            }
        }
    }
}
