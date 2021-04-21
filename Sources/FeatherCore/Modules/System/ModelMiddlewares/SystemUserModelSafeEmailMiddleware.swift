//
//  UserModelContentMiddleware.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 08. 11..
//

/// we use this middleware to ensure that email addresses are always saved as lowercased strings
struct SystemUserModelSafeEmailMiddleware: ModelMiddleware {

    /// transform email to lowercase before create an entry
    func create(model: UserAccountModel, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        model.email = model.email.lowercased()
        return next.create(model, on: db)
    }

    /// transform email to lowercase before update an entry
    func update(model: UserAccountModel, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        model.email = model.email.lowercased()
        return next.update(model, on: db)
    }
}
