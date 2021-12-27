//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 19..
//

import SwiftSitemap

public struct WebSitemapTemplate: TemplateRepresentable {

    var context: WebSitemapContext
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "Y-MM-dd"
        return formatter
    }()
    
    public init(_ context: WebSitemapContext) {
        self.context = context
    }

    @TagBuilder
    public func render(_ req: Request) -> Tag {
        UrlSet {
            for item in context.items {
                Url {
                    Loc(Feather.baseUrl + item.slug.safePath())
                    LastMod(Self.formatter.string(from: item.date))
                }
            }
        }
    }
}
