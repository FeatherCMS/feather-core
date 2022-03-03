//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 03. 01..
//


struct FeatherGuestUserAuthenticator: AsyncRequestAuthenticator {

    func authenticate(request req: Request) async throws {
        let role: FeatherRole? = try await req.invokeAllFirstAsync(.guestRole)
        req.auth.login(FeatherUser(id: .init(), level: .guest, roles: [role].compactMap { $0 }))
    }
}
