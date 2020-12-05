//
//  UserObject.swift
//  FeatherCoreApi
//
//  Created by Tibor Bodecs on 2020. 12. 05..
//

import Foundation

public struct UserObject: Codable {

    public let email: String
    
    public init(email: String) {
        self.email = email
    }
}
