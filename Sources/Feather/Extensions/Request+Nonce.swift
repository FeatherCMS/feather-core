//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

public extension Request {

    /// returns a nonce session key for a given type and identifier
    private func getNonceSessionKey(id: String) -> String {
        "feather-" + id + "-nonce"
    }

    /// generates a nonce and saves it in the session storage for a given key and identifier
    func generateNonce(for id: String) -> String {
        let token = [UInt8].random(count: 32).base64
        session.data[getNonceSessionKey(id: id)] = token
        return token
    }

    /// validates a nonce, then removes a given nonce from the session storage
    func useNonce(id: String, token: String) throws {
        let nonceSessionKey = getNonceSessionKey(id: id)
        
        guard let existingToken = session.data[nonceSessionKey] else {
            throw Abort(.forbidden)
        }
        session.data[nonceSessionKey] = nil
        guard existingToken == token else {
            throw Abort(.forbidden)
        }
    }
}
