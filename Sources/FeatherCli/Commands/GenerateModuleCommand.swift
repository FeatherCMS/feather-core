//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 13..
//

import Foundation
import FeatherCliGenerator


struct GenerateModuleCommand: Command {
    
    static let name = "module"
        
    struct Signature: CommandSignature {}

    let help = "This command will generate a Feather module."

    func run(using context: CommandContext, signature: Signature) throws {
        let moduleName = context.console.ask("Module name?").capitalized
        var models: [ModelDescriptor] = []
        var addNextModel = false
        repeat {
            let modelName = context.console.ask("Model name?").capitalized

            var properties: [PropertyDescriptor] = []
            var addNextProperty = false
            repeat {
                let name = context.console.ask("Property name (field)?")
                let type = PropertyDescriptor.DatabaseFieldType(rawValue: context.console.choose("Select a type", from: PropertyDescriptor.DatabaseFieldType.allCases.map(\.rawValue)))!
                let isRequired = context.console.choose("Is required?", from: ["Yes", "No"]) == "Yes"
                var searchable = false
                if type == .string {
                    searchable = context.console.choose("Searchable?", from: ["Yes", "No"]) == "Yes"
                }
                let orderabe = context.console.choose("Ordering is allowed?", from: ["Yes", "No"]) == "Yes"
                let view = PropertyDescriptor.FormFieldType(rawValue: context.console.choose("Form field type", from: PropertyDescriptor.FormFieldType.allCases.map(\.rawValue)))!

                let property = PropertyDescriptor(name: name,
                                                  databaseType: type,
                                                  formFieldType: view,
                                                  isRequired: isRequired,
                                                  isSearchable: searchable,
                                                  isOrderingAllowed: orderabe)

                properties.append(property)
                console.info("Field added.")
                addNextProperty = context.console.choose("Add another property?", from: ["Yes", "No"]) == "Yes"
            }
            while addNextProperty

            models.append(ModelDescriptor(name: modelName, properties: properties))
            console.info("Model added.")
            addNextModel = context.console.choose("Add another model?", from: ["Yes", "No"]) == "Yes"
        }
        while addNextModel
        
        var path = CommandLine.arguments[0]
        if path.contains("DerivedData") {
            let arr = path.components(separatedBy: "/")
            path = arr.dropLast(arr.count-3).joined(separator: "/")
        }
        
        let outputPath = context.console.ask("Output path <\(path)>:")
        if !outputPath.isEmpty {
            path = outputPath
        }

        console.info("Generating module at `\(path)`")
        try generateModule(ModuleDescriptor(name: moduleName, models: models), at: path)
        console.info("Module generated.")
    }
    
    // MARK: - helpers
    
    private func forceCreateDirectory(at url: URL) throws {
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }

    private func forceWrite(_ contents: String, at url: URL) throws {
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
        try contents.write(to: url, atomically: true, encoding: .utf8)
    }
    
    private func generateModule(_ moduleDescriptor: ModuleDescriptor, at path: String) throws {
        let baseUrl = URL(fileURLWithPath: path)

        // Module
        let moduleUrl = baseUrl.appendingPathComponent(moduleDescriptor.name)
        let moduleFileContents = ModuleGenerator(moduleDescriptor).generate()
        let moduleFile = moduleUrl.appendingPathComponent(moduleDescriptor.name + "Module.swift")
        try forceCreateDirectory(at: moduleUrl)
        try forceWrite(moduleFileContents, at: moduleFile)
        
        let builderFileContents = ModuleBuilderGenerator(moduleDescriptor).generate()
        let builderFile = moduleUrl.appendingPathComponent(moduleDescriptor.name + "Builder.swift")
        try forceWrite(builderFileContents, at: builderFile)
        
        // APIs
        let apiUrl = baseUrl.appendingPathComponent(moduleDescriptor.name + "Api")
        let moduleApiFileContents = ApiModuleGenerator(moduleDescriptor).generate()
        let moduleApiFile = apiUrl.appendingPathComponent(moduleDescriptor.name + ".swift")
        try forceCreateDirectory(at: apiUrl)
        try forceWrite(moduleApiFileContents, at: moduleApiFile)
        
        // Routers
        let routersUrl = moduleUrl.appendingPathComponent("Routers")
        let routerFileContents = RouterGenerator(moduleDescriptor).generate()
        let routerFile = routersUrl.appendingPathComponent(moduleDescriptor.name + "Router.swift")
        try forceCreateDirectory(at: routersUrl)
        try forceWrite(routerFileContents, at: routerFile)
        
        // Database
        let databaseUrl = moduleUrl.appendingPathComponent("Database")
        let migrationsUrl = databaseUrl.appendingPathComponent("Migrations")
        let modelsUrl = databaseUrl.appendingPathComponent("Models")
        let migrationFileContents = MigrationGenerator(moduleDescriptor).generate()
        let migrationFile = migrationsUrl.appendingPathComponent(moduleDescriptor.name + "Migrations.swift")
        try forceCreateDirectory(at: databaseUrl)
        try forceCreateDirectory(at: migrationsUrl)
        try forceCreateDirectory(at: modelsUrl)
        try forceWrite(migrationFileContents, at: migrationFile)
        
        // Controllers
        let controllersUrl = moduleUrl.appendingPathComponent("Controllers")
        try forceCreateDirectory(at: controllersUrl)
        let apiControllerUrl = controllersUrl.appendingPathComponent("Api")
        try forceCreateDirectory(at: apiControllerUrl)
        let adminControllerUrl = controllersUrl.appendingPathComponent("Admin")
        try forceCreateDirectory(at: adminControllerUrl)
        
        let editorsUrl = moduleUrl.appendingPathComponent("Editors")
        try forceCreateDirectory(at: editorsUrl)

        // Templates
//        let templatesUrl = moduleUrl.appendingPathComponent("Templates")
//        try forceCreateDirectory(at: templatesUrl)
//        let contextsUrl = templatesUrl.appendingPathComponent("Contexts")
//        try forceCreateDirectory(at: contextsUrl)
//        let htmlUrl = templatesUrl.appendingPathComponent("Html")
//        try forceCreateDirectory(at: htmlUrl)
        
        for modelDescriptor in moduleDescriptor.models {
            let prefix = moduleDescriptor.name + modelDescriptor.name

            let modelFileContents = ModelGenerator(modelDescriptor, module: moduleDescriptor.name).generate()
            let modelFile = modelsUrl.appendingPathComponent(prefix + "Model.swift")
            try forceWrite(modelFileContents, at: modelFile)
            
            let modelApiFileContents = ApiModelGenerator(modelDescriptor, module: moduleDescriptor.name).generate()
            let modelApiFile = apiUrl.appendingPathComponent(prefix + ".swift")
            try forceWrite(modelApiFileContents, at: modelApiFile)
            
            let apiControllerFileContents = ApiControllerGenerator(modelDescriptor, module: moduleDescriptor.name).generate()
            let apiControllerFile = apiControllerUrl.appendingPathComponent(prefix + "ApiController.swift")
            try forceWrite(apiControllerFileContents, at: apiControllerFile)
            
            let adminControllerFileContents = AdminControllerGenerator(modelDescriptor, module: moduleDescriptor.name).generate()
            let adminControllerFile = adminControllerUrl.appendingPathComponent(prefix + "AdminController.swift")
            try forceWrite(adminControllerFileContents, at: adminControllerFile)
            
            let editorFileContents = EditorGenerator(modelDescriptor, module: moduleDescriptor.name).generate()
            let editorFile = editorsUrl.appendingPathComponent(prefix + "Editor.swift")
            try forceWrite(editorFileContents, at: editorFile)
        }
    }
}
