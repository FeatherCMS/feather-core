//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 19..
//

import SwiftSitemap

final class SystemSitemapTemplate: AbstractTemplate<SystemSitemapContext> {

    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "Y-MM-dd"
        return formatter
    }()
    
    override func render(_ req: Request) -> Tag {
        UrlSet {
            for item in context.items {
                Url {
                    Loc(req.feather.baseUrl + item.slug.safePath())
                    LastMod(Self.formatter.string(from: item.date))
                }
            }
        }
    }
}
