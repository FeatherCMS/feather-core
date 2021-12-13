//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

import Foundation

import Vapor
import SwiftHtml


public struct SortingTemplate: TemplateRepresentable {
    
    unowned var req: Request
    var context: SortingContext
    
    public init(_ req: Request, _ context: SortingContext) {
        self.req = req
        self.context = context
    }

    private func indicator() -> String {
        let isSortedAscending = (req.getQuery("sort") ?? context.sort.rawValue) == "asc"
        let arrow = isSortedAscending ? "▴" : "▾"
        let order = req.getQuery("order")

        if (context.isDefault && order == nil) || order == context.key {
            return "" + arrow
        }
        return ""
    }
    
    private func query() -> String {
        var queryItems = req.queryDictionary
        /// we check the old order and sort values
        let oldOrder = queryItems["order"]
        let oldSort = queryItems["sort"]
        /// we update the order based on the input
        queryItems["order"] = context.key
        let isDefaultOrder = context.isDefault
        /// if there was no old order and this is the default order that means we have to use the default sort
        if oldOrder == nil && isDefaultOrder {
            queryItems["sort"] = (context.sort == .asc) ? "desc" : "asc"
        }
        /// if the old order was equal with the field key we just flip the sort
        else if oldOrder == context.key {
            if let sort = oldSort {
                queryItems["sort"] = (sort == "asc") ? "desc" : sort
            }
            else {
                queryItems["sort"] = (context.sort == .asc) ? "desc" : "asc"
            }
        }
        /// otherwise this is a completely new order we can remove the sort key completely
        else {
            queryItems.removeValue(forKey: "sort")
        }
        return "\(req.url.path)?\(queryItems.queryString)"
    }
    
    @TagBuilder
    public var tag: Tag {
        A((context.label ?? context.key.uppercasedFirst) + indicator())
            .href(query())
    }
}



