//
//  FeatherModule.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

/// abstract module interface
public protocol FeatherModule {

    /// The location of the bundled resources
    ///
    /// e.g. Bundle.module.resourceURL?.appendingPathComponent("Bundle")
    ///
    var bundleUrl: URL? { get }
    
    /// a unique identifier for the module
    ///
    /// default value is the lowercased name of the module by dropping the module suffix
    ///
    static var featherIdentifier: String { get }
    
    static var featherName: String { get }

    /// module boot function
    func boot(_ app: Application) throws
    
    /// module config function, runs after the boot function
    func config(_ app: Application) throws
}


public extension FeatherModule {
    
    var bundleUrl: URL? { nil }
    
    static var featherIdentifier: String {
        String(describing: self).dropLast(6).lowercased()
    }

    static var featherName: String {
        featherIdentifier.capitalized
    }    
    
    func boot(_ app: Application) throws {
        // nothing to do here...
    }
    
    func config(_ app: Application) throws {
        // nothing to do here...
    }
}
