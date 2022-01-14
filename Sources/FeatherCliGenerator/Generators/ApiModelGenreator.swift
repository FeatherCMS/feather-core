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

        return """
        public extension \(module) {
            
            struct \(descriptor.name): FeatherApiModel {
                public typealias Module = \(module)
            }
        }

        public extension \(module).\(descriptor.name) {
        
                // MARK: -
        
                struct List: Codable {
                    public let id: UUID
                    \(generateFields())
        
                    \(generateInit())
                }
        
                // MARK: -
        
                struct Detail: Codable {
                    public let id: UUID
                    \(generateFields())
        
                    \(generateInit())
                }
        
                // MARK: -
        
                struct Create: Codable {
                    \(generateFields())
        
                    \(generateInit(withId: false))
                }


                // MARK: -
        
                struct Update: Codable {
                    \(generateFields())
        
                    \(generateInit(withId: false))
                }

                // MARK: -
        
                struct Patch: Codable {
                    \(generateFields())
        
                    \(generateInit(withId: false))
                }
        
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
    
    func generateInit(withId: Bool = true) -> String {
        let arguments = descriptor.properties.map { generateInitArgument($0) }.joined(separator: ",\n    ")
        let setters = descriptor.properties.map { generateInitSetter($0.name) }.joined(separator: "\n    ")
        
        if withId {
            return """
            public init(id: UUID,
                \(arguments)) {
                self.id = id
                \(setters)
                }
            """
        }
        return """
        public init(\(arguments)) {
            \(setters)
            }
        """
    }
}

