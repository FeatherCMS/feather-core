//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 24..
//

import SwiftSgml

struct DefaultSystemModuleTemplate: SystemModuleTemplate {

    init() {}

    func index(_ context: SystemIndexContext, @TagBuilder _ builder: () -> Tag) -> AbstractTemplate<SystemIndexContext> {
        SystemIndexTemplate(context, builder)
    }
}
