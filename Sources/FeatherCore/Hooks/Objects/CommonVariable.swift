//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 03..
//

public struct CommonVariable: Codable {

    public let key: String
    public let value: String?
    public let name: String
    public let notes: String?

    public init(key: String, value: String? = nil, name: String, notes: String? = nil) {
        self.key = key
        self.value = value
        self.name = name
        self.notes = notes
    }
}
