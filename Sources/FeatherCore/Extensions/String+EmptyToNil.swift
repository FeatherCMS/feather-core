//
//  String+EmptyToNil.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 08. 23..
//

public extension String {

    /// turns an empty string to a nil value
    var emptyToNil: String? { isEmpty ? nil : self }
}
