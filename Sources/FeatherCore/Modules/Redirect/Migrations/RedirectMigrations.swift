//
//  RedirectMigrations.swift
//
//
//  Created by Steve Tibbett on 2021-12-19
//

import Fluent

struct RedirectMigrations {

    struct v1: AsyncMigration {

        func prepare(on db: Database) async throws {
            try await db.schema(RedirectRuleModel.schema)
                .id()
                .field(RedirectRuleModel.FieldKeys.v1.source, .string, .required)
                .field(RedirectRuleModel.FieldKeys.v1.destination, .string, .required)
                .field(RedirectRuleModel.FieldKeys.v1.statusCode, .int, .required)
                .field(RedirectRuleModel.FieldKeys.v1.notes, .string)
                .unique(on: RedirectRuleModel.FieldKeys.v1.source)
                .create()
        }
        
        func revert(on db: Database) async throws {
            try await db.schema(RedirectRuleModel.schema).delete()
        }
    }
}
