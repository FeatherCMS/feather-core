//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 22..
//


struct CommonMigration_v1: Migration {

    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(CommonVariableModel.schema)
                .id()
                .field(CommonVariableModel.FieldKeys.key, .string, .required)
                .field(CommonVariableModel.FieldKeys.name, .string, .required)
                .field(CommonVariableModel.FieldKeys.value, .string)
                .field(CommonVariableModel.FieldKeys.notes, .string)
                .unique(on: CommonVariableModel.FieldKeys.key)
                .create(),
        ])
    }

    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(CommonVariableModel.schema).delete(),
        ])
    }
}

