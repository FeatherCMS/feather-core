//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 19..
//

import Vapor
import SwiftSitemap

public struct SitemapTemplate: TemplateRepresentable {

    unowned var req: Request
    var context: String
    
    public init(_ req: Request, context: String) {
        self.req = req
        self.context = context
    }

    public var tag: Tag {
        UrlSet {
            Url {
                Loc("http://localhost/")
                LastMod("2021-12-19")
//                ChangeFreq(.monthly)
//                Priority(0.5)
            }
        }
    }
}
