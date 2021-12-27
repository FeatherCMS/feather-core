//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

struct UserAccountModelMiddleware: AsyncModelMiddleware {
    
    func create(model: UserAccountModel, on db: Database, next: AnyAsyncModelResponder) async throws {
        model.email = model.email.lowercased()
        return try await next.create(model, on: db)
    }
    
    func update(model: UserAccountModel, on db: Database, next: AnyAsyncModelResponder) async throws {
        model.email = model.email.lowercased()
        return try await next.update(model, on: db)
    }
}
