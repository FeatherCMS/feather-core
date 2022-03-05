//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

import Vapor
import FeatherApi

public extension FeatherApiModel {

    static var pathIdComponent: PathComponent {
        .init(stringLiteral: ":" + pathIdKey)
    }

    static func getIdParameter(_ req: Request) -> UUID? {
        req.parameters.get(pathIdKey)?.uuid
    }
}
