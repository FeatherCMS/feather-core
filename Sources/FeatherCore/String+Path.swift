//
//  String+Path.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

import Foundation

public extension String {

    func slugify() -> String {
        let allowed = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789-_.")
        return trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: .init(identifier: "en_US"))
            .components(separatedBy: allowed.inverted)
            .filter { $0 != "" }
            .joined(separator: "-")
    }

    func safeSlug() -> String {
        var slug = self
        if slug.hasPrefix("/") {
            slug = String(slug.dropFirst())
        }
        if slug.hasSuffix("/") {
            slug = String(slug.dropLast())
        }
        return slug
    }
    
    func safePath() -> String {
        let components = split(separator: "/")
        var newPath = "/" + components.joined(separator: "/")
        if let last = components.last, !last.contains(".") {
           newPath += "/"
        }
        return newPath
    }
}
