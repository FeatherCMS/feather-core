//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

import Fluent
import Fluent

final class SystemVariableModel: FeatherDatabaseModel {
    typealias Module = SystemModule

    struct FieldKeys {
        struct v1 {
            static var key: FieldKey { "key" }
            static var name: FieldKey { "name" }
            static var value: FieldKey { "value" }
            static var notes: FieldKey { "notes" }
        }
    }

    @ID() var id: UUID?
    @Field(key: FieldKeys.v1.key) var key: String
    @Field(key: FieldKeys.v1.name) var name: String
    @Field(key: FieldKeys.v1.value) var value: String?
    @Field(key: FieldKeys.v1.notes) var notes: String?

    init() {}

    init(id: UUID? = nil,
         key: String,
         name: String,
         value: String? = nil,
         notes: String? = nil)
    {
        self.id = id
        self.key = key
        self.name = name
        self.value = value
        self.notes = notes
    }
}
