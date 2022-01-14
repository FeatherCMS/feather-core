//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//


public struct ApiControllerGenerator {
    
    let descriptor: ModelDescriptor
    let module: String
    
    public init(_ descriptor: ModelDescriptor, module: String) {
        self.descriptor = descriptor
        self.module = module
    }
    
    public func generate() -> String {
        return """
        extension \(module).\(descriptor.name).List: Content {}
        extension \(module).\(descriptor.name).Detail: Content {}

        struct \(module)AccountApiController: ApiController {
            typealias ApiModel = \(module).\(descriptor.name)
            typealias DatabaseModel = \(module)\(descriptor.name)Model
            
            func listOutput(_ req: Request, _ models: [DatabaseModel]) async throws -> [\(module).\(descriptor.name).List] {
                models.map { model in
                    \(generateInit())
                }
            }
            
            func detailOutput(_ req: Request, _ model: DatabaseModel) async throws -> \(module).\(descriptor.name).Detail {
                \(generateInit())
            }
            
            func createInput(_ req: Request, _ model: DatabaseModel, _ input: \(module).\(descriptor.name).Create) async throws {
                \(generateUpsertFields())
            }
            
            func updateInput(_ req: Request, _ model: DatabaseModel, _ input: \(module).\(descriptor.name).Update) async throws {
                \(generateUpsertFields())
            }
            
            func patchInput(_ req: Request, _ model: DatabaseModel, _ input: \(module).\(descriptor.name).Patch) async throws {
                \(generatePatchFields())
            }
            
            func validators(optional: Bool) -> [AsyncValidator] {
                []
            }
        }
        """
    }
}

private extension ApiControllerGenerator {
    
    func generatePatchField(_ property: PropertyDescriptor) -> String {
        "model.\(property.name) = input.\(property.name) ?? model.\(property.name)"
    }

    func generatePatchFields() -> String {
        descriptor.properties.map { generatePatchField($0) }.joined(separator: "\n    ")
    }
    
    func generateUpsertField(_ property: PropertyDescriptor) -> String {
        "model.\(property.name) = input.\(property.name)"
    }

    func generateUpsertFields() -> String {
        descriptor.properties.map { generateUpsertField($0) }.joined(separator: "\n    ")
    }

    
    func generateInitArgument(_ property: PropertyDescriptor) -> String {
        "\(property.name): model.\(property.name)"
    }
    
    func generateInit() -> String {
        let arguments = descriptor.properties.map { generateInitArgument($0) }.joined(separator: ",\n    ")

        return """
        .init(id: model.uuid,
            \(arguments))
        """
    }
}

