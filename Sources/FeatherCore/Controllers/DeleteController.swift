//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 29..
//

public final class DeleteForm: AbstractForm {

    public init() {
        super.init()

        self.action.method = .post
        self.submit = "Delete"
    }
}


public protocol DeleteController: ModelController {
    
    func deleteAccess(_ req: Request) async throws -> Bool
    func beforeDelete(_ req: Request, _ model: DatabaseModel) async throws
    func afterDelete(_ req: Request, _ model: DatabaseModel) async throws
}

public extension DeleteController {
    
    func deleteAccess(_ req: Request) async throws -> Bool {
        try await req.checkAccess(for: ApiModel.permission(for: .delete))
    }
    
    func beforeDelete(_ req: Request, _ model: DatabaseModel) async throws {
        
    }
    
    func afterDelete(_ req: Request, _ model: DatabaseModel) async throws {
        
    }
}
