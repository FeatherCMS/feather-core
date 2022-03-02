//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

public extension String {

    func safePath() -> String {
        let components = split(separator: "/")
        var newPath = "/" + components.joined(separator: "/")
        if let last = components.last, !last.contains(".") {
           newPath += "/"
        }
        // make urls with scheme safe...
        newPath = newPath.replacingOccurrences(of: ":/", with: "://")
        if newPath.contains("://") {
            return String(newPath.dropFirst())
        }
        return newPath
    }
}
