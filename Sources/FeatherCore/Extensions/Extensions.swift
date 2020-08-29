//
//  Extensions.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 08. 23..
//

public extension String {

    /// replaces the last path component (separated by slashes) of a string with a new value
    func replaceLastPath(_ value: String) -> String {
        var components = split(separator: "/").dropLast().map(String.init)
        components.append(value)
        return "/" + components.joined(separator: "/") + "/"
    }
}

public extension ViperModel where IDValue == UUID {

    /// unique view identifier implementation for a viper model
    var viewIdentifier: String { id!.uuidString }
}

