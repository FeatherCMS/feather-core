//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//

import Foundation

public struct ApiModuleGenerator {
    
    let descriptor: ModuleDescriptor
    
    public init(_ descriptor: ModuleDescriptor) {
        self.descriptor = descriptor
    }

    public func generate() -> String {
        "public enum \(descriptor.name): FeatherApiModule {}"
    }
    

}
