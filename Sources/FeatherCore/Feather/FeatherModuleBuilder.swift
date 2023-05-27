//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 27..
//

/// abstract module builder class for creating feather modules
open class FeatherModuleBuilder {

    /// simple init method
    public required init() {}

    /// this method should return a valid feather module instance
    open func build() -> FeatherModule {
        fatalError("The abstract Feather module builder can't create any modules. ¯\\_(ツ)_/¯")
    }
}
