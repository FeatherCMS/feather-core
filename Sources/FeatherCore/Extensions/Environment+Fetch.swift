//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

import Vapor

public extension Environment {

    /// fetches a key from the environment, if the key does not exists it'll result in a fatal error
    static func fetch(_ key: String) -> String {
        guard let value = Environment.get(key) else {
            fatalError("""
                \(key) is not defined in the Environment.
                Check the README or the documentation for how to set environment variables.
                """)
        }
        return value
    }
}
