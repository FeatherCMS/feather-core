//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

/// module manager for Feather
public final class FeatherModuleManager {

    /// list of available modules
    public private(set) var modules: [FeatherModule]
    
    /// create a new instance with an array of modules
    init(_ modules: [FeatherModule]) {
        self.modules = modules
    }
    
    /// returns modules that have bundled resources
    public var modulesWithBundle: [FeatherModule] {
        modules.filter({ type(of: $0).bundleUrl != nil })
    }

    /// add a new module to the system
    func add(_ modules: [FeatherModule]) {
        self.modules += modules
    }
}
