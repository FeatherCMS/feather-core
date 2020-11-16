//
//  Application+IsDebug.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 11. 14..
//

import Vapor

public extension Application {

    /// is the app running in debug mode (environment is not release and nor production)
    var isDebug: Bool { !environment.isRelease && environment != .production }
}
