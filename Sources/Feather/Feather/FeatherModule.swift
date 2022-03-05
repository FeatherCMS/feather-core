//
//  FeatherModule.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

/// abstract module interface
public protocol FeatherModule {

    /// The location of the bundled resources
    ///
    /// e.g. Bundle.module.resourceURL?.appendingPathComponent("Bundle")
    ///
    static var bundleUrl: URL? { get }
    
    /// a unique identifier for the module
    ///
    /// default value is the lowercased name of the module by dropping the module suffix
    ///
    static var uniqueKey: String { get }
    
    /// name of the module (always singular & capitalized)
    static var name: String { get }

    /// module boot function
    func boot(_ app: Application) throws
    
    /// module config function, runs after the boot function
    func config(_ app: Application) throws
}


public extension FeatherModule {
    
    static var bundleUrl: URL? { nil }
    
    static var uniqueKey: String {
        String(describing: self).dropLast(6).lowercased()
    }

    static var name: String {
        uniqueKey.capitalized
    }    
    
    func boot(_ app: Application) throws {
        // nothing to do here...
    }
    
    func config(_ app: Application) throws {
        // nothing to do here...
    }
}


public func Sample<T: FeatherModule>(_ module: T.Type, file name: String) -> String {
    do {
        guard let url = module.bundleUrl?.appendingPathComponent("Sample").appendingPathComponent(name) else {
            return ""
        }
        return try String(contentsOf: url, encoding: .utf8)
    }
    catch {
        return ""
    }
}

// Sample(Module.self, file: "lorem.png")
