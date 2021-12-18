//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 28..
//

import Foundation

public struct TableContext {

    public let id: String
    public let columns: [ColumnContext]
    public let rows: [RowContext]
    public let actions: [LinkContext]
    public let options: TableOptionContext

    public init(id: String,
                columns: [ColumnContext],
                rows: [RowContext],
                actions: [LinkContext] = [],
                options: TableOptionContext = .init()) {
        self.id = id
        self.columns = columns
        self.rows = rows
        self.actions = actions
        self.options = options
    }
}
