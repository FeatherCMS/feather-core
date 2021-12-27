//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

extension Environment {

    private static func featherKey(_ key: String) -> String {
        ("feather_" + key).uppercased()
    }

    private static func fetch(_ key: String) -> String? {
        get(featherKey(key))
    }
    
    static func featherRequired(_ key: String) -> String {
        guard let value = fetch(key) else {
            let msg = """
                The following key `\(featherKey(key))` is not defined in the environment file.
                Check the README or the documentation for how to set environment variables.
                """
            fatalError(msg)
        }
        return value
    }
    
    static func featherString(_ key: String, _ `default`: String) -> String {
        fetch(key) ?? `default`
    }

    static func featherBool(_ key: String, _ `default`: Bool = false) -> Bool {
        Bool(fetch(key) ?? String(`default`)) ?? `default`
    }
    
    static func featherInt(_ key: String, _ `default`: Int) -> Int {
        Int(fetch(key) ?? String(`default`)) ?? `default`
    }
    
}
