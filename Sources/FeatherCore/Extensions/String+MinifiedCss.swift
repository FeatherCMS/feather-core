//
//  String+MinifiedCss.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 14..
//

import Foundation

public extension String {
    
    public var minifiedCss: String {
        var css = self
        let patterns = [
            "/[*](.*?)[*]/": "",    /// comments
            "\n": "",               /// extra newlines
            "\\s+": " ",            /// extra spaces...
            "\\s*:\\s*": ":",
            "\\s*\\,\\s*": ",",
            "\\s*\\{\\s": "{",
            "\\s*\\}\\s*": "}",
            "\\s*\\;\\s*": ";",
            "\\{\\s*": "{",
        ]

        for pattern in patterns {
            let regex = try! NSRegularExpression(pattern: pattern.key, options: .caseInsensitive)
            let range = NSRange(css.startIndex..., in: css)
            css = regex.stringByReplacingMatches(in: css,
                                                 options: [],
                                                 range: range,
                                                 withTemplate: pattern.value)
        }        
        return css
    }
}
