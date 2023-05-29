//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 28..
//

//final class SystemModuleModel: FeatherDatabaseModel {
//    typealias Module = SystemModule
//
//    struct FieldKeys {
//        struct v1 {
//            static var name: FieldKey { "name" }
//            static var status: FieldKey { "status" }
//        }
//    }
//
//    @ID() var id: UUID?
//    @Field(key: FieldKeys.v1.module) var module: String
//    @Field(key: FieldKeys.v1.status) var status: FeatherMetadata.Status
//
//    init() {
//        
//    }
//
//    init(id: UUID? = nil,
//         module: String,
//         status: FeatherMetadata.Status = .draft)
//    {
//        self.id = id
//        self.module = module
//        self.model = model
//    
//    }
//}
