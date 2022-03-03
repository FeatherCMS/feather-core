//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 24..
//

import SwiftSgml

public protocol SystemModuleTemplate: FeatherTemplate {
    func index(_ context: SystemIndexContext, @TagBuilder _ builder: () -> Tag) -> AbstractTemplate<SystemIndexContext>
}
