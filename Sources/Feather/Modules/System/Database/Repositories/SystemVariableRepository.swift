//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 24..
//

struct SystemVariableRepository: FeatherModelRepository {
    typealias DatabaseModel = SystemVariableModel

    public private(set) var req: Request
    
    init(_ req: Request) {
        self.req = req
    }
}
