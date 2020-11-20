//
//  UserModel+Auth.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 06. 02..
//

/// users can be authenticated using the session storage
extension UserModel: SessionAuthenticatable {
    typealias SessionID = UUID

    var sessionID: SessionID { id! }
}

