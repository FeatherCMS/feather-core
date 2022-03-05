//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 04..
//

import Vapor
import FeatherApi

public struct ValidationAbort: AbortError {

    public var abort: Abort
    public var message: String?
    public var details: [FeatherErrorDetail]

    public var reason: String { abort.reason }
    public var status: HTTPStatus { abort.status }
    
    public init(abort: Abort, message: String? = nil, details: [FeatherErrorDetail]) {
        self.abort = abort
        self.message = message ?? abort.reason
        self.details = details
    }
}
