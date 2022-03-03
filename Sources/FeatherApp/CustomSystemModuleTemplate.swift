//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 24..
//

import Feather
import SwiftHtml

struct CustomSystemModuleTemplate: SystemModuleTemplate {

    func index(_ context: SystemIndexContext, _ builder: () -> Tag) -> AbstractTemplate<SystemIndexContext> {
        CustomIndexTemplate(context, builder)
    }
}

