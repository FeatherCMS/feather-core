//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 19..
//

public struct User: Codable {

    public let id: UUID
    public let email: String
    public let isRoot: Bool
    public let permissions: [Permission]

}

extension User: SessionAuthenticatable {
    public typealias SessionID = UUID

    public var sessionID: SessionID { id }
}

