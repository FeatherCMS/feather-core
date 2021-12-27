//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

public protocol DetailController: ModelController {
    func detailAccess(_ req: Request) async throws -> Bool    
}

public extension DetailController {

    func detailAccess(_ req: Request) async throws -> Bool {
        try await req.checkAccess(for: ApiModel.permission(for: .detail))
    }
}
