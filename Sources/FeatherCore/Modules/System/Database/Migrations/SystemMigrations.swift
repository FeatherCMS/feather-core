//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

import Fluent

struct SystemMigrations {

    struct v1: AsyncMigration {

        func prepare(on db: Database) async throws {
            
            try await db.schema(SystemVariableModel.schema)
                .id()
                .field(SystemVariableModel.FieldKeys.v1.key, .string, .required)
                .field(SystemVariableModel.FieldKeys.v1.name, .string, .required)
                .field(SystemVariableModel.FieldKeys.v1.value, .string)
                .field(SystemVariableModel.FieldKeys.v1.notes, .string)
                .unique(on: SystemVariableModel.FieldKeys.v1.key)
                .create()
            
            try await db.schema(SystemPermissionModel.schema)
                .id()
                .field(SystemPermissionModel.FieldKeys.v1.namespace, .string, .required)
                .field(SystemPermissionModel.FieldKeys.v1.context, .string, .required)
                .field(SystemPermissionModel.FieldKeys.v1.action, .string, .required)
                .field(SystemPermissionModel.FieldKeys.v1.name, .string, .required)
                .field(SystemPermissionModel.FieldKeys.v1.notes, .string)
                .unique(on: SystemPermissionModel.FieldKeys.v1.namespace,
                            SystemPermissionModel.FieldKeys.v1.context,
                            SystemPermissionModel.FieldKeys.v1.action)
                .create()
            
            try await db.schema(SystemMetadataModel.schema)
                .id()
                .field(SystemMetadataModel.FieldKeys.v1.module, .string, .required)
                .field(SystemMetadataModel.FieldKeys.v1.model, .string, .required)
                .field(SystemMetadataModel.FieldKeys.v1.reference, .uuid, .required)
                .field(SystemMetadataModel.FieldKeys.v1.title, .string)
                .field(SystemMetadataModel.FieldKeys.v1.excerpt, .string)
                .field(SystemMetadataModel.FieldKeys.v1.imageKey, .string)
                .field(SystemMetadataModel.FieldKeys.v1.date, .date, .required)
                .field(SystemMetadataModel.FieldKeys.v1.slug, .string, .required)
                .field(SystemMetadataModel.FieldKeys.v1.status, .string, .required)
                .field(SystemMetadataModel.FieldKeys.v1.feedItem, .bool, .required)
                .field(SystemMetadataModel.FieldKeys.v1.canonicalUrl, .string)
                .field(SystemMetadataModel.FieldKeys.v1.filters, .array(of: .string), .required)
                .field(SystemMetadataModel.FieldKeys.v1.css, .string)
                .field(SystemMetadataModel.FieldKeys.v1.js, .string)
                .unique(on: SystemMetadataModel.FieldKeys.v1.slug)
                .unique(on: SystemMetadataModel.FieldKeys.v1.module,
                            SystemMetadataModel.FieldKeys.v1.model,
                            SystemMetadataModel.FieldKeys.v1.reference)
                .create()
            
        }
        
        func revert(on db: Database) async throws {
            try await db.schema(SystemPermissionModel.schema).delete()
            try await db.schema(SystemMetadataModel.schema).delete()
            try await db.schema(SystemVariableModel.schema).delete()
        }
    }
}
