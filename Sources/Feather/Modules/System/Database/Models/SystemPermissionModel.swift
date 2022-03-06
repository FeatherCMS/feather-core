//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

import Foundation
import Fluent
import FeatherApi

final class SystemPermissionModel: FeatherDatabaseModel {
    typealias Module = SystemModule

    struct FieldKeys {
        struct v1 {
            static var namespace: FieldKey { "namespace" }
            static var context: FieldKey { "context" }
            static var action: FieldKey { "action" }
            static var name: FieldKey { "name" }
            static var notes: FieldKey { "notes" }
        }
    }

    @ID() var id: UUID?
    @Field(key: FieldKeys.v1.namespace) var namespace: String
    @Field(key: FieldKeys.v1.context) var context: String
    @Field(key: FieldKeys.v1.action) var action: String
    @Field(key: FieldKeys.v1.name) var name: String
    @Field(key: FieldKeys.v1.notes) var notes: String?
    
    init() { }

    init(id: UUID? = nil,
         namespace: String,
         context: String,
         action: String,
         name: String,
         notes: String? = nil) {
        self.id = id
        self.namespace = namespace
        self.context = context
        self.action = action
        self.name = name
        self.notes = notes
    }
}


extension SystemPermissionModel {
    
    var featherPermission: FeatherPermission {
        .init(namespace: namespace, context: context, action: .init(action))
    }
}
