//
//  String+TrailingSlash.swift
//  FeatherCore
//
//  Created by Julian Gentges on 10.08.20.
//

import Foundation

public extension String {

    var withTrailingSlash: String {
        if hasSuffix("/") {
            return self
        }
        return self + "/"
    }
}
