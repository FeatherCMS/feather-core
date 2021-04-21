//
//  UserListObject.swift
//  UserModuleApi
//
//  Created by Tibor Bodecs on 2020. 12. 21..
//

import Foundation

public struct AccountListObject: Codable {

    public var id: UUID
    public var email: String

    public init(id: UUID,
                email: String)
    {
        self.id = id
        self.email = email
    }
}
