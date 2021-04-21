//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//

/// can be used to display a standalone module menu on the admin
public struct FeatherAdminMenuController {

    public let key: String
    
    public init(key: String) {
        self.key = key
    }

    public func moduleView(req: Request) throws -> EventLoopFuture<View> {
        let menusResult: [[SystemMenu]] = req.invokeAll("admin-menus")
        let menu = menusResult.flatMap { $0 }.first { $0.key == key }
        return req.view.render("System/Admin/Menu", ["menu": menu])
    }
}
