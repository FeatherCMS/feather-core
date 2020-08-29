//
//  Environmetn+FetchValue.swift
//  
//
//  Created by Michael Critz on 8/9/20.
//

import Vapor

public extension Environment {

    static func fetch(_ key: String) -> String {
        guard let value = Environment.get(key) else {
            precondition(false, """
                \(key) is not defined in the Environment.
                Check README.md or documentation for how to set environment variables.
                """)
        }
        return value
    }
    
    static func path(_ key: String) -> String {
        let rawPath = fetch(key)
        let resolved = rawPath.expandingTildeInPath
        let path = resolved.withTrailingSlash
        
        return path
    }
}
