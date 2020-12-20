//
//  ViperApiViewController.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 20..
//

/// a protocol on top of the admin view controller, where the associated model is a viper model
public protocol ViperApiContentController: ApiContentController where Model: ViperModel {
    
    /// we need to associate a generic module type
    associatedtype Module: ViperModule
}

public extension ViperApiContentController where  Model.IDValue == UUID  {

    private func viperAccess(_ key: String, req: Request) -> EventLoopFuture<Bool> {
        let name = [Module.name, Model.name, key].joined(separator: ".").replacingOccurrences(of: "_", with: ".")
        return req.checkUserAccess(name)
    }

    func accessList(req: Request) -> EventLoopFuture<Bool> { viperAccess("list", req: req) }
    func accessGet(req: Request) -> EventLoopFuture<Bool> { viperAccess("get", req: req) }
    func accessCreate(req: Request) -> EventLoopFuture<Bool> { viperAccess("create", req: req) }
    func accessUpdate(req: Request) -> EventLoopFuture<Bool> { viperAccess("update", req: req) }
    func accessPatch(req: Request) -> EventLoopFuture<Bool> { viperAccess("update", req: req) }
    func accessDelete(req: Request) -> EventLoopFuture<Bool> { viperAccess("delete", req: req) }
}
