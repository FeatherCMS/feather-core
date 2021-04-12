//
//  ViperBuilder.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 05. 02..
//

open class FeatherModuleBuilder {

    public required init() {}
    
    open func build() -> FeatherModule {
        fatalError("The abstract ViperBuilder can't build any modules.")
    }
}
