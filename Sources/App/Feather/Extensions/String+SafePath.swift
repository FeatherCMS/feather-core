//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

import Foundation

extension String {

    func safePath() -> String {
        let components = split(separator: "/")
        var newPath = "/" + components.joined(separator: "/")
        if let last = components.last, !last.contains(".") {
           newPath += "/"
        }
        return newPath
    }
}
