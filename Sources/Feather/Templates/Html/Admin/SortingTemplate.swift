//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

import Vapor
import SwiftHtml

public struct SortingTemplate: TemplateRepresentable {
    
    var context: SortingContext
    
    public init(_ context: SortingContext) {
        self.context = context
    }

    private func indicator(_ req: Request) -> String {
        let isSortedAscending = (req.getQuery("sort") ?? context.defaultSort.rawValue) == "asc"
        let arrow = isSortedAscending ? "▴" : "▾"
        let order = req.getQuery("order")

        if (context.isDefault && order == nil) || order == context.key {
            return "" + arrow
        }
        return ""
    }
    
    private func query(_ req: Request) -> String {
        var queryItems = req.queryDictionary
        let oldOrder = queryItems["order"]
        let oldSort = queryItems["sort"]
        
        var newOrder = oldOrder
        if context.key != oldOrder {
            newOrder = context.key
        }
        if context.isDefault {
            newOrder = nil
        }

        var newSort: String? = ((oldSort ?? context.defaultSort.rawValue) == "asc") ? "desc" : "asc"
        if oldOrder != newOrder {
            newSort = context.defaultSort.rawValue
        }
        if context.defaultSort.rawValue == newSort {
            newSort = nil
        }
        queryItems["order"] = newOrder
        queryItems["sort"] = newSort
        queryItems = queryItems.compactMapValues { $0 }
        return req.url.path.safePath() + (queryItems.queryString.isEmpty ? "" : ("?" + queryItems.queryString))
    }
    
    @TagBuilder
    public func render(_ req: Request) -> Tag {
        A((context.label ?? context.key.capitalized) + indicator(req))
            .href(query(req))
    }
}



