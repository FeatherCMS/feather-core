//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 28..
//

import Foundation

public struct AdminListPageContext {

    public let title: String
    public let isSearchable: Bool
    public let table: TableContext
    public let pagination: PaginationContext
    public let navigation: [LinkContext]
    public let breadcrumbs: [LinkContext]
    
    public init(title: String,
                isSearchable: Bool,
                table: TableContext,
                pagination: PaginationContext,
                navigation: [LinkContext] = [],
                breadcrumbs: [LinkContext] = []) {
        self.title = title
        self.isSearchable = isSearchable
        self.table = table
        self.pagination = pagination
        self.navigation = navigation
        self.breadcrumbs = breadcrumbs
    }
}
