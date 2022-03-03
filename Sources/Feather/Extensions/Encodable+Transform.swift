//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 24..
//

public extension Encodable {

    /// transforms an encodable object into another decodable if possible.
    func transform<U: Decodable>(to type: U.Type) throws -> U {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
}
