//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

extension FeatherUser: SessionAuthenticatable {
    public typealias SessionID = UUID

    public var sessionID: SessionID { id }
}
