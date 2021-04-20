//
//  ViperBuilder.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 05. 02..
//

open class FeatherModuleBuilder {

    public required init() {}
    
    open func build() -> FeatherModule {
        fatalError("The abstract Feather module builder can't create any modules. ¯\\_(ツ)_/¯")
    }
}
