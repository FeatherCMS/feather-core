//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//

import Foundation

public struct ModelGenerator {
    
    let descriptor: ModelDescriptor
    let module: String
    
    public init(_ descriptor: ModelDescriptor, module: String) {
        self.descriptor = descriptor
        self.module = module
    }

    public func generate() -> String {
        """
        final class \(module)\(descriptor.name)Model: FeatherDatabaseModel {
            typealias Module = \(module)Module
        
            \(generateFieldKeys())

            @ID() var id: UUID?
            \(generateFields())
        
            init() {}

            \(generateInit())
        }
        """
    }
}

private extension ModelGenerator {

    func generateFieldKey(_ name: String) -> String {
        "    static var \(name): FieldKey { \"\(name)\" }"
    }
    
    func generateFieldKeys() -> String {
        let keys = descriptor.properties.map {
            generateFieldKey($0.name)
        }.joined(separator: "\n        ")

        return """
        struct FieldKeys {
                struct v1 {
                \(keys)
                }
            }
        """
    }
    
    func generateField(_ property: PropertyDescriptor) -> String {
        "@Field(key: FieldKeys.v1.\(property.name)) var \(property.name): \(property.swiftType)"
    }
    
    func generateFields() -> String {
        descriptor.properties.map { generateField($0) }.joined(separator: "\n    ")
    }

    func generateInitArgument(_ property: PropertyDescriptor) -> String {
        "     \(property.name): \(property.swiftType)"
    }
    
    func generateInitSetter(_ name: String) -> String {
        "    self.\(name) = \(name)"
    }
    
    func generateInit() -> String {
        let arguments = descriptor.properties.map { generateInitArgument($0) }.joined(separator: ",\n    ")
        let setters = descriptor.properties.map { generateInitSetter($0.name) }.joined(separator: "\n    ")
        
        return """
        init(id: UUID,
            \(arguments)) {
                self.id = id
            \(setters)
            }
        """
    }
}
