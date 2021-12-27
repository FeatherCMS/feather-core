//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

extension Dictionary where Key == String, Value == String {

    /// converts a dictionary to a URL query string
    var queryString: String {
        map { $0 + "=" + $1 }.joined(separator: "&")
    }
}
