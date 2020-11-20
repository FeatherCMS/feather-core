//
//  AdminController.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

struct AdminController {

    func homeView(req: Request) throws -> EventLoopFuture<View> {
        req.leaf.render(template: "Admin/Home")
    }
}
