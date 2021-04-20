//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 03. 31..
//

public struct TableRow: Encodable {

    public let id: String
    public let cells: [TableCell]

    public init(id: String, cells: [TableCell]) {
        self.id = id
        self.cells = cells
    }
}
