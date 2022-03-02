//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 19..
//

import Foundation

public struct ModuleBuilderGenerator {
    
    let descriptor: ModuleDescriptor
    
    public init(_ descriptor: ModuleDescriptor) {
        self.descriptor = descriptor
    }
    
    public func generate() -> String {
        """
        @_cdecl("create\(descriptor.name)Module")
        public func create\(descriptor.name)Module() -> UnsafeMutableRawPointer {
            return Unmanaged.passRetained(\(descriptor.name)Builder()).toOpaque()
        }

        public final class \(descriptor.name)Builder: FeatherModuleBuilder {

            public override func build() -> FeatherModule {
                \(descriptor.name)Module()
            }
        }

        """
    }
}

