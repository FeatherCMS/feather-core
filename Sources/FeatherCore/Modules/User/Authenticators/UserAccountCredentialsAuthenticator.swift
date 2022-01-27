//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

struct UserAccountCredentialsAuthenticator: AsyncCredentialsAuthenticator {

    struct Input: Content {
        let email: String
        let password: String
    }
    
    func authenticate(credentials: Input, for req: Request) async throws {
        guard let model = try await UserAccountModel.findWithPermissionsBy(email: credentials.email, on: req.db) else {
            return
        }
        if let isValid = try? Bcrypt.verify(credentials.password, created: model.password), isValid {
            req.auth.login(model.featherAccount)
        }
        
    }
}

