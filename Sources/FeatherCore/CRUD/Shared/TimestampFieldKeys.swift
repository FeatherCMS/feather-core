//
//  TimestampFieldKeys.swift
//  
//
//  Created by Denis Martin on 01/05/2021.
//

public protocol TimestampFieldKeys { }

public extension TimestampFieldKeys {
    static var updatedAt: FieldKey { "updated_at" }
    static var createdAt: FieldKey { "created_at" }
    static var deletedAt: FieldKey { "deleted_at" }
}

