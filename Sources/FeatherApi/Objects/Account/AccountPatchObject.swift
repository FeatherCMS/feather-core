//
//  UserPatchObject.swift
//  UserModuleApi
//
//  Created by Tibor Bodecs on 2020. 12. 21..
//

import Foundation

public struct AccountPatchObject: Codable {

    public var email: String?
    public var password: String?
    public var root: Bool?

    public init(email: String? = nil,
                password: String? = nil,
                root: Bool? = nil)
    {
        self.email = email
        self.password = password
        self.root = root
    }
}
