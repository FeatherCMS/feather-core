//
//  Environmetn+FetchValue.swift
//  FeatherCore
//
//  Created by Michael Critz on 8/9/20.
//

import Vapor

public extension Environment {

    /// fetches a key from the environment, if the key does not exists it'll result in a fatal error
    static func fetch(_ key: String) -> String {
        guard let value = Environment.get(key) else {
            fatalError("""
                \(key) is not defined in the Environment.
                Check README.md or documentation for how to set environment variables.
                """)
        }
        return value
    }
    
    /// returns a path from the environment with ~ extended and cointaining a trailing / character
    static func path(_ key: String) -> String {
        let rawPath = fetch(key)
        let resolved = rawPath.expandingTildeInPath
        let path = resolved.withTrailingSlash
        
        return path
    }
}
