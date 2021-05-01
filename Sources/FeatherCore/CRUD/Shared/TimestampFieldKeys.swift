//
//  TimestampFieldKeys.swift
//  
//
//  Created by Denis Martin on 01/05/2021.
//

public protocol TimestampFieldKeys { }

public extension TimestampFieldKeys {
    static var updated_at: FieldKey { "updated_at" }
    static var created_at: FieldKey { "created_at" }
    static var deleted_at: FieldKey { "deleted_at" }
}

