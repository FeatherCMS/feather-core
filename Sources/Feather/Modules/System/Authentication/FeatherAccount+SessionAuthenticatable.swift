//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

import FeatherApi

extension FeatherUser: SessionAuthenticatable {
    public typealias SessionID = UUID

    public var sessionID: SessionID { id }
}
