//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

struct CommonMigrations {

    struct v1: AsyncMigration {

        func prepare(on db: Database) async throws {
            try await db.schema(CommonVariableModel.schema)
                .id()
                .field(CommonVariableModel.FieldKeys.v1.key, .string, .required)
                .field(CommonVariableModel.FieldKeys.v1.name, .string, .required)
                .field(CommonVariableModel.FieldKeys.v1.value, .string)
                .field(CommonVariableModel.FieldKeys.v1.notes, .string)
                .unique(on: CommonVariableModel.FieldKeys.v1.key)
                .create()
        }

        func revert(on db: Database) async throws {
            try await db.schema(CommonVariableModel.schema).delete()
        }
    }
}
