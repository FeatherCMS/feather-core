//
//  SystemVariableListObject.swift
//  SystemModuleApi
//
//  Created by Tibor Bodecs on 2020. 12. 20..
//

import Foundation

public struct VariableListObject: Codable {
    
    public var id: UUID
    public var key: String
    public var value: String?

    public init(id: UUID,
                key: String,
                value: String? = nil)
    {
        self.id = id
        self.key = key
        self.value = value
    }
}
