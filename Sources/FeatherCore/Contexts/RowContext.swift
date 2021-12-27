//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 28..
//

public struct RowContext {

    public let id: String
    public let cells: [CellContext]
    
    public init(id: String, cells: [CellContext]) {
        self.id = id
        self.cells = cells
    }
}

