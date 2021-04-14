//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

public extension HookArguments {
    
    var req: Request {
        self["req"] as! Request
    }

    var app: Application {
        self["app"] as! Application
    }

    var routes: RoutesBuilder {
        self["routes"] as! RoutesBuilder
    }
}
