//
//  EventLoopFuture+Response.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//


public extension EventLoopFuture where Value: ResponseEncodable {

    /// encode the response as a Response? type, a helper method for frontend page hooks
    func encodeOptionalResponse(for req: Request) -> EventLoopFuture<Response?> {
        encodeResponse(for: req).map { $0 as Response? }
    }
}
