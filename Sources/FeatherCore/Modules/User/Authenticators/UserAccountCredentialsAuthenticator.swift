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
    
    // @NOTE: https://github.com/vapor/vapor/issues/2735
    func authenticate(request: Request) async throws {
        _ = try await request.body.collect(max: nil).get()

        let credentials: Credentials
        do {
            credentials = try request.content.decode(Credentials.self)
        }
        catch {
            return
        }
        return try await self.authenticate(credentials: credentials, for: request)
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
