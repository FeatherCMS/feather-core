//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 03. 30..
//

public final class Table: Codable {

    public let id: String?
    public let columns: [TableColumn]
    public var rows: [TableRow]

    public init(id: String? = nil, columns: [TableColumn], rows: [TableRow] = []) {
        
        self.id = id
        self.columns = columns
        self.rows = rows
    }
}
