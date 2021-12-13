//
//  File.swift
//
//
//  Created by Tibor Bodecs on 2021. 11. 15..
//

import Vapor
import SwiftCss

public struct CssRenderer {
        
    public func render(_ css: StylesheetRepresentable) -> Response {
        let res = StylesheetRenderer().render(css.stylesheet)
        return Response(status: .ok,
                        headers: ["content-type": "text/css"],
                        body: .init(string: res))
    }
}

public extension Request {
    var css: CssRenderer { .init() }
}

