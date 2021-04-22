//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

public extension HookArguments {
    
    var req: Request {
        get {
            self["req"] as! Request
        }
        set {
            self["req"] = newValue
        }
    }

    var app: Application {
        get {
            self["app"] as! Application
        }
        set {
            self["app"] = newValue
        }
    }

    var routes: RoutesBuilder {
        get {
            self["routes"] as! RoutesBuilder
        }
        set {
            self["routes"] = newValue
        }
    }
    
    var permission: Permission {
        get {
            self["permission"] as! Permission
        }
        set {
            self["permission"] = newValue
        }
    }
    
    var metadata: Metadata {
        get {
            self["metadata"] as! Metadata
        }
        set {
            self["metadata"] = newValue
        }
    }
}
