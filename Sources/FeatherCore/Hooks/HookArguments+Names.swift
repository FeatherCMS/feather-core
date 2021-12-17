//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

import Vapor
import FeatherCoreApi

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
    
    var permission: FeatherPermission {
        get {
            self["permission"] as! FeatherPermission
        }
        set {
            self["permission"] = newValue
        }
    }
    
    var metadata: WebMetadata.Detail {
        get {
            self["metadata"] as! WebMetadata.Detail
        }
        set {
            self["metadata"] = newValue
        }
    }

    var nextInstallStep: String {
        get {
            self["next-install-step"] as! String
        }
        set {
            self["next-install-step"] = newValue
        }
    }
    
    var currentInstallStep: String {
        get {
            self["current-install-step"] as! String
        }
        set {
            self["current-install-step"] = newValue
        }
    }
}
