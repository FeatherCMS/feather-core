//
//  String+ExpandingTilde.swift
//  FeatherCore
//
//  Created by Julian Gentges on 10.08.20.
//

import Foundation

public extension String {

    var expandingTildeInPath: String {
        var path = NSString(string: self).expandingTildeInPath
        
        if hasSuffix("/") {
            path += "/"
        }
        return path
    }
}
