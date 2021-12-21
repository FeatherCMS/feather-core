//
//  RedirectRuleModel.swift
//  
//
//  Created by Steve Tibbett on 2021-12-19..
//

import Vapor
import Fluent

final class RedirectRuleModel: FeatherModel {
    typealias Module = RedirectModule

    struct FieldKeys {
        struct v1 {
            static var source: FieldKey { "source" }
            static var destination: FieldKey { "destination" }
            static var statusCode: FieldKey { "status_code" }
            static var notes: FieldKey { "notes" }
        }
    }

    @ID() var id: UUID?
    @Field(key: FieldKeys.v1.source) var source: String
    @Field(key: FieldKeys.v1.destination) var destination: String
    @Field(key: FieldKeys.v1.statusCode) var statusCode: Int
    @Field(key: FieldKeys.v1.notes) var notes: String?

    init() { }
    
    init(id: UUID? = nil,
         source: String,
         destination: String,
         statusCode: Int = Int(RedirectType.normal.status.code),
         notes: String? = nil)
    {
        self.id = id
        self.source = source
        self.destination = destination
        self.statusCode = statusCode
        self.notes = notes
    }
}

extension RedirectRuleModel {

    static func findWithSource(source: String, on db: Database) async throws -> RedirectRuleModel {
        guard
            let model = try await RedirectRuleModel.query(on: db)
                .filter(\.$source == source)
                .first()
        else {
            throw Abort(.notFound)
        }
        return model
    }

}
