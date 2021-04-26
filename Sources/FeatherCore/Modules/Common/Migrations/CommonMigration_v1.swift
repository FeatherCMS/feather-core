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

            db.schema(CommonFileGroupModel.schema)
                .id()
                .field(CommonFileGroupModel.FieldKeys.path, .string, .required)
                .field(CommonFileGroupModel.FieldKeys.title, .string, .required)
                .field(CommonFileGroupModel.FieldKeys.excerpt, .string)
                .field(CommonFileGroupModel.FieldKeys.notes, .string)
                .create(),

            db.schema(CommonFileModel.schema)
                .id()
                .field(CommonFileModel.FieldKeys.key, .string, .required)
                .field(CommonFileModel.FieldKeys.name, .string, .required)
                .field(CommonFileModel.FieldKeys.type, .string, .required)
                .field(CommonFileModel.FieldKeys.size, .int, .required)
                .field(CommonFileModel.FieldKeys.tag, .string)
                .field(CommonFileModel.FieldKeys.width, .int)
                .field(CommonFileModel.FieldKeys.height, .int)
                .field(CommonFileModel.FieldKeys.groupId, .uuid, .required)
                .foreignKey(CommonFileModel.FieldKeys.groupId, references: CommonFileGroupModel.schema, .id)
                .create(),
        ])
    }

    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(CommonVariableModel.schema).delete(),
            db.schema(CommonFileModel.schema).delete(),
            db.schema(CommonFileGroupModel.schema).delete(),
        ])
    }
}

