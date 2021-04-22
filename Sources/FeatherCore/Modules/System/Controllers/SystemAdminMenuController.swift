//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//

/// can be used to display a standalone module menu on the admin
public struct SystemAdminMenuController {

    public let key: String
    
    public init(key: String) {
        self.key = key
    }

    public func moduleView(req: Request) throws -> EventLoopFuture<View> {
        let menusResult: [FrontendMenu] = req.invokeAll(.adminMenu)
        let menu = menusResult.first { $0.key == key }
        return req.view.render("System/Admin/Menu", ["menu": menu])
    }
}
