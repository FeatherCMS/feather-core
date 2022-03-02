//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//

// @TODO: optional patch fields
public struct ApiModelGenerator {
    
    let descriptor: ModelDescriptor
    let module: String
    
    public init(_ descriptor: ModelDescriptor, module: String) {
        self.descriptor = descriptor
        self.module = module
    }
    
    public func generate() -> String {

        let props = descriptor.properties.map { Property(name: $0.name, type: $0.swiftType, access: .public) }
        let idProps = [Property(name: "id", type: "UUID")] + props
        
        let patchProps = descriptor.properties.map {
            Property(name: $0.name, type: $0.databaseType.rawValue.capitalized + "?", value: "nil", access: .public)
        }
        
        let list = Object(type: "struct", name: "List", inherits: ["Codable"], properties: idProps, generateInit: true)
        let detail = Object(type: "struct", name: "Detail", inherits: ["Codable"], properties: idProps, generateInit: true)
        let create = Object(type: "struct", name: "Create", inherits: ["Codable"], properties: props, generateInit: true)
        let update = Object(type: "struct", name: "Update", inherits: ["Codable"], properties: props, generateInit: true)
        let patch = Object(type: "struct", name: "Patch", inherits: ["Codable"], properties: patchProps, generateInit: true)
                
        return """
        public extension \(module) {
            
            struct \(descriptor.name): FeatherApiModel {
                public typealias Module = \(module)
            }
        }

        public extension \(module).\(descriptor.name) {
        
            // MARK: -
        
        \(list.debugDescription.indentLines())
            // MARK: -
        
        \(detail.debugDescription.indentLines())
            // MARK: -
        
        \(create.debugDescription.indentLines())
            // MARK: -
        
        \(update.debugDescription.indentLines())
            // MARK: -
        
        \(patch.debugDescription.indentLines())
        
        }
        """
    }
}

private extension ApiModelGenerator {

    func generateField(_ property: PropertyDescriptor) -> String {
        "public let \(property.name): \(property.swiftType)"
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
    
    func generateInit(withId: Bool = true, optionals: Bool = false) -> String {
        let arguments = descriptor.properties.map { generateInitArgument($0) }.joined(separator: ",\n    ")
        let setters = descriptor.properties.map { generateInitSetter($0.name) }.joined(separator: "\n    ")
        
        if withId {
            return """
            public init(
                id: UUID,
                \(arguments)
            ) {
                self.id = id
            \(setters.indentLines())
            }
            """
        }
        return """
        public init(
        \(arguments.indentLines())
        ) {
        \(setters.indentLines())
        }
        """
    }
    
    
}

