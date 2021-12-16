//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Foundation

extension UserAccount {

    public struct Create: Codable {
        public var email: String
        public var password: String
        public var isRoot: Bool

        public init(email: String,
                    password: String,
                    isRoot: Bool = false)
        {
            self.email = email
            self.password = password
            self.isRoot = isRoot
        }
    }
}
