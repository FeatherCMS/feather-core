//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 07..
//

import Foundation

extension String {

    /**
     Converts the first letter of the string to an upper case letter

     - returns: The string with a capitalized first letter
     */
    var uppercasedFirst: String {
        guard count > 1 else {
            return uppercased()
        }
        let startIndex = index(startIndex, offsetBy: 1)
        let begin = self[..<startIndex]
        let end = self[startIndex...]
        let first = begin.uppercased()
        return first + end
    }
}
