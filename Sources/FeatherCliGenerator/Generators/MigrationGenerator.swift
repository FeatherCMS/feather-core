//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//

import Foundation

public struct MigrationGenerator {

    let descriptor: ModuleDescriptor
    
    public init(_ descriptor: ModuleDescriptor) {
        self.descriptor = descriptor
    }
    
    func generatePropertyField(_ property: PropertyDescriptor, modelName: String) -> String {
        ".field(\(descriptor.name)\(modelName)Model.FieldKeys.v1.\(property.name), .\(property.databaseType)" + (property.isRequired ? ", .required)": ")")
    }

    func generateModelPrepare(_ model: ModelDescriptor) -> String {
        // .unique(on: UserAccountModel.FieldKeys.v1.email)
        let fields = model.properties.map { generatePropertyField($0, modelName: model.name) }.joined(separator: "\n                ")
        
        return """
        try await db.schema(\(descriptor.name)\(model.name)Model.schema)
                        .id()
                        \(fields)
                        .create()
        """
    }
    
    func generateModelRevert(_ model: ModelDescriptor) -> String {
        "try await db.schema(\(descriptor.name)\(model.name)Model.schema).delete()"
    }
    
    public func generate() -> String {
        let prepare = descriptor.models.map { generateModelPrepare($0) }.joined(separator: "\n\n")
        let revert = descriptor.models.map { generateModelRevert($0) }.joined(separator: "\n")
    
        return """
        struct \(descriptor.name)Migrations {
            
            struct v1: AsyncMigration {

                func prepare(on db: Database) async throws {
                   \(prepare)
                }

                func revert(on db: Database) async throws {
                    \(revert)
                }
            }
        }
        """
    }
}
