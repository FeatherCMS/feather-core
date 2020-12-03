//
//  UserModelCredentialsAuthenticator.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 06. 01..
//

struct UserModelCredentialsAuthenticator: CredentialsAuthenticator {
    
    struct Input: Content {
        let email: String
        let password: String
    }

    func authenticate(credentials: Input, for req: Request) -> EventLoopFuture<Void> {
        UserModel.findWithPermissionsBy(email: credentials.email, on: req.db).map {
            do {
                if let user = $0, try Bcrypt.verify(credentials.password, created: user.password) {
                    req.auth.login(user)
                }
            }
            catch {
                // do nothing...
            }
        }
    }
}

