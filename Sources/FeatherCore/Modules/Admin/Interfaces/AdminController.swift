//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

public protocol AdminController: AdminListController,
                                 AdminDetailController,
                                 AdminCreateController,
                                 AdminUpdateController,
                                 AdminDeleteController
{
    func setUpRoutes(_ routes: RoutesBuilder)
}

public extension AdminController {
    
    func setUpRoutes(_ routes: RoutesBuilder) {
        setUpListRoutes(routes)
        setUpDetailRoutes(routes)
        setUpCreateRoutes(routes)
        setUpUpdateRoutes(routes)
        setUpDeleteRoutes(routes)
    }
}

