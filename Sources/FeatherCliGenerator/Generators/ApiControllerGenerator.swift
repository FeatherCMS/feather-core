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

        let validators = descriptor.properties.filter { $0.isRequired }.map {
            "KeyedContentValidator<\($0.databaseType.rawValue.capitalized)>.required(\"\($0.name)\", optional: optional)"
        }.joined(separator: "\n")
        
        let ctrl = Object(type: "struct",
                          name: "\(module)\(descriptor.name)ApiController",
                          inherits: ["ApiController"],
                          typealiases: [
                            .init(name: "ApiModel", value: "\(module).\(descriptor.name)"),
                            .init(name: "DatabaseModel", value: "\(module)\(descriptor.name)Model"),
                        ], functions: [
                            .init(name: "listOutput",
                                  arguments: [
                                    .init(name: "req", type: "Request", label: "_"),
                                    .init(name: "models", type: "[DatabaseModel]", label: "_"),
                                  ],
                                  returns: "[\(module).\(descriptor.name).List]",
                                  body: """
                                    models.map { model in
                                    \(generateInit().indentLines())
                                    }
                                    """,
                                  modifiers: ["async", "throws"]),
                            
                            .init(name: "detailOutput",
                                  arguments: [
                                    .init(name: "req", type: "Request", label: "_"),
                                    .init(name: "model", type: "DatabaseModel", label: "_"),
                                  ],
                                  returns: "\(module).\(descriptor.name).Detail",
                                  body: """
                                    \(generateInit())
                                    """,
                                 modifiers: ["async", "throws"]),
                            
                            .init(name: "createInput",
                                  arguments: [
                                    .init(name: "req", type: "Request", label: "_"),
                                    .init(name: "model", type: "DatabaseModel", label: "_"),
                                    .init(name: "input", type: "\(module).\(descriptor.name).Create", label: "_"),
                                  ],
                                  body: """
                                    \(generateUpsertFields())
                                    """,
                                 modifiers: ["async", "throws"]),
                            
                            .init(name: "updateInput",
                                  arguments: [
                                    .init(name: "req", type: "Request", label: "_"),
                                    .init(name: "model", type: "DatabaseModel", label: "_"),
                                    .init(name: "input", type: "\(module).\(descriptor.name).Update", label: "_")
                                  ],
                                  body: """
                                    \(generateUpsertFields())
                                    """,
                                 modifiers: ["async", "throws"]),
                            
                            .init(name: "patchInput",
                                  arguments: [
                                    .init(name: "req", type: "Request", label: "_"),
                                    .init(name: "model", type: "DatabaseModel", label: "_"),
                                    .init(name: "input", type: "\(module).\(descriptor.name).Patch", label: "_")
                                  ],
                                  body: """
                                    \(generatePatchFields())
                                    """,
                                 modifiers: ["async", "throws"]),
                            
                            .init(name: "validators",
                                  arguments: [
                                    .init(name: "optional", type: "Bool"),
                                  ],
                                  returns: "[AsyncValidator]",
                                  body: """
                                    \(validators)
                                    """,
                                 wrappers: ["@AsyncValidatorBuilder"]),
                                
                        ])
        
        return """
        extension \(module).\(descriptor.name).List: Content {}
        extension \(module).\(descriptor.name).Detail: Content {}
        
        \(ctrl.debugDescription)
        """
    }
}

private extension ApiControllerGenerator {
    
    func generatePatchField(_ property: PropertyDescriptor) -> String {
        "model.\(property.name) = input.\(property.name) ?? model.\(property.name)"
    }

    func generatePatchFields() -> String {
        descriptor.properties.map { generatePatchField($0) }.joined(separator: "\n")
    }
    
    func generateUpsertField(_ property: PropertyDescriptor) -> String {
        "model.\(property.name) = input.\(property.name)"
    }

    func generateUpsertFields() -> String {
        descriptor.properties.map { generateUpsertField($0) }.joined(separator: "\n")
    }

    
    func generateInitArgument(_ property: PropertyDescriptor) -> String {
        "\(property.name): model.\(property.name)"
    }
    
    func generateInit() -> String {
        let arguments = descriptor.properties.map { generateInitArgument($0) }.joined(separator: ",\n")

        return """
        .init(
            id: model.uuid,
        \(arguments.indentLines())
        )
        """
    }
}

