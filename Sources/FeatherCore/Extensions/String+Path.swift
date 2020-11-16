//
//  String+Path.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

import Foundation

public extension String {

    /// removes unsafe characters from a string, so it can be used as a slug
    func slugify() -> String {
        let allowed = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789-_.")
        return trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: .init(identifier: "en_US"))
            .components(separatedBy: allowed.inverted)
            .filter { $0 != "" }
            .joined(separator: "-")
    }

    /// expands the ~ character in a given path
    var expandingTildeInPath: String {
        var path = NSString(string: self).expandingTildeInPath
        
        if hasSuffix("/") {
            path += "/"
        }
        return path
    }

    /// adds a trailing / character to a path string if necessary
    var withTrailingSlash: String {
        if hasSuffix("/") {
            return self
        }
        return self + "/"
    }

    /// trims slashes from a path (also removes duplicate / characters)
    func trimmingSlashes() -> String {
        split(separator: "/").joined(separator: "/")
    }

    /// remove duplicate / characters from a string and adds a leading slash and a trailing / if the path has no extension (e.g. /foo/bar.html)
    func safePath() -> String {
        let components = split(separator: "/")
        var newPath = "/" + components.joined(separator: "/")
        if let last = components.last, !last.contains(".") {
           newPath += "/"
        }
        return newPath
    }
    
    /// replaces the last path component (separated by slashes) of a string with a new value
    func replacingLastPath(_ value: String) -> String {
        var components = split(separator: "/").dropLast().map(String.init)
        components.append(value)
        return "/" + components.joined(separator: "/") + "/"
    }
}
