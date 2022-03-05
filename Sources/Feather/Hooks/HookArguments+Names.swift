//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

import Vapor
import FeatherApi

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

    var metadata: FeatherMetadata {
        get {
            self["metadata"] as! FeatherMetadata
        }
        set {
            self["metadata"] = newValue
        }
    }

    var installInfo: SystemInstallInfo {
        SystemInstallInfo(currentStep: req.feather.config.install.currentStep,
                          nextStep: nextInstallStep,
                          performStep: req.query[req.feather.config.install.nextQueryKey] ?? false)
    }
    
}

extension HookArguments {
    
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
