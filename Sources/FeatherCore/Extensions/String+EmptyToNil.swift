//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 03. 01..
//

public extension String {

    // turns an empty string into a nil value
    var emptyToNil: String? {
        isEmpty ? nil : self
    }
}
