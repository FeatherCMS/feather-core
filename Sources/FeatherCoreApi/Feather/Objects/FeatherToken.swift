//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

public struct FeatherToken: Codable {
    public let id: UUID
    public let value: String
    public let user: FeatherAccount
    
    public init(id: UUID, value: String, user: FeatherAccount) {
        self.id = id
        self.value = value
        self.user = user
    }
}
