//
//  UserGetObject.swift
//  UserModuleApi
//
//  Created by Tibor Bodecs on 2020. 12. 21..
//

import Foundation

public struct AccountGetObject: Codable {

    public var id: UUID
    public var email: String
    public var root: Bool

    public init(id: UUID,
                email: String,
                root: Bool)
    {
        self.id = id
        self.email = email
        self.root = root
    }
}
