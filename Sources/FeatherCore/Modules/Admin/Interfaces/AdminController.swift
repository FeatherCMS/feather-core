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
    func setupRoutes(_ routes: RoutesBuilder)
}

public extension AdminController {
    
    func setupRoutes(_ routes: RoutesBuilder) {
        setupListRoutes(routes)
        setupDetailRoutes(routes)
        setupCreateRoutes(routes)
        setupUpdateRoutes(routes)
        setupDeleteRoutes(routes)
    }
}

