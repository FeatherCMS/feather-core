//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 21..
//

struct GenerateModelCommand: Command {
    
    static let name = "model"
        
    struct Signature: CommandSignature {

//        @Argument(name: "name", help: "The name of the API object")
//        var name: String
//
//        @Argument(name: "fields", help: "List of fields (id:UUID,name:String)")
//        var fields: String
    }

    let help = "This command will generate CRUD objects for a given API model."

    func run(using context: CommandContext, signature: Signature) throws {
//        let objectName = signature.name.capitalized
//        context.console.info(objectName)

        let moduleName = context.console.ask("Module name?")
        
        let modelName = context.console.ask("Model name?")

        var fields: [FieldDescription] = []
        var addNext: Bool = false
        repeat {
            let name = context.console.ask("Property name (field)?")
            let type = FieldDescription.FieldType(rawValue: context.console.choose("Select a type", from: FieldDescription.FieldType.allCases.map(\.rawValue)))!
            let isRequired = context.console.choose("Is required?", from: ["Yes", "No"]) == "Yes"
            var searchable = false
            if type == .string {
                searchable = context.console.choose("Searchable?", from: ["Yes", "No"]) == "Yes"
            }
            let orderabe = context.console.choose("Ordering is allowed?", from: ["Yes", "No"]) == "Yes"
            let view = FieldDescription.FormFieldType(rawValue: context.console.choose("Form field type", from: FieldDescription.FormFieldType.allCases.map(\.rawValue)))!
            
            
            let field = FieldDescription(name: name,
                                         type: type,
                                         isRequired: isRequired,
                                         isSearchable: searchable,
                                         isOrderingAllowed: orderabe,
                                         formFieldType: view)
            
            fields.append(field)
            
            console.info("Field created...")

            addNext = context.console.choose("Add another one?", from: ["Yes", "No"]) == "Yes"
        }
        while ( addNext )
        
        
//        let path = CommandLine.arguments[0]
        let path = "/Users/tib/"

        let description = ModelDescription(module: moduleName, name: modelName, fields: fields)
        let model = createModel(description)
        let migration = createMigration(description)
        let editForm = createEditForm(description)
        let api = createApi(description)
        
        let listObject = createListObject(description)
        let getObject = createGetObject(description)
        let createObject = createCreateObject(description)
        let updateObject = createUpdateObject(description)
        let patchObject = createPatchObject(description)
        
        try model.write(toFile: path + "\(moduleName)\(modelName)Model.swift", atomically: true, encoding: .utf8)
        try migration.write(toFile: path + "\(moduleName)Migration_v1.swift", atomically: true, encoding: .utf8)
        try editForm.write(toFile: path + "\(moduleName)\(modelName)EditForm.swift", atomically: true, encoding: .utf8)
        try api.write(toFile: path + "\(moduleName)\(modelName)Api.swift", atomically: true, encoding: .utf8)
        
        try listObject.write(toFile: path + "\(modelName)ListObject.swift", atomically: true, encoding: .utf8)
        try getObject.write(toFile: path + "\(modelName)GetObject.swift", atomically: true, encoding: .utf8)
        try createObject.write(toFile: path + "\(modelName)CreateObject.swift", atomically: true, encoding: .utf8)
        try updateObject.write(toFile: path + "\(modelName)UpdateObject.swift", atomically: true, encoding: .utf8)
        try patchObject.write(toFile: path + "\(modelName)PatchObject.swift", atomically: true, encoding: .utf8)
    }
    
    func createModel(_ description: ModelDescription) -> String {
        let module = description.module.lowercased().capitalized
        let model = description.name.lowercased().capitalized
        
        
        let fieldKeys = description.fields.map { f in
            "static var \(f.name): FieldKey { \"\(f.name)\" }"
        }.joined(separator: "\n\t\t")
        
        let fields = description.fields.map { f in
            "@Field(key: FieldKeys.\(f.name) var \(f.name): \(f.swiftTypeValue)"
        }.joined(separator: "\n\t")
        
        let initParams = description.fields.map { f in
            "\(f.name): \(f.swiftTypeValue)"
        }.joined(separator: "\n\t\t")
        
        let initCall = description.fields.map { f in
            "self.\(f.name) = \(f.name)"
        }.joined(separator: "\n\t\t ")
        
        let allowedOrders = description.fields.filter(\.isOrderingAllowed).map { f in
            "FieldKeys.\(f.name)"
        }.joined(separator: "\n\t\t\t")
        
        let search = description.fields.filter(\.isSearchable).map { f in
            "\\.$\(f.name) ~~ term"
        }.joined(separator: "\n\t\t\t")
        
        let str = """
        //
        //  MenuEditForm.swift
        //  FrontendModule
        //
        //  Created by Tibor Bodecs on 2020. 11. 15..
        //

        final class \(module)\(model)Model: FeatherModel {
            typealias Module = \(module)Module

            static let modelKey: String = "\(model.lowercased())s"
            static let name: FeatherModelName = "\(model)"

            struct FieldKeys {
                \(fieldKeys)
            }

            // MARK: - fields

            @ID() var id: UUID?
            \(fields)

            init() { }
            
            init(id: UUID? = nil,
                 \(initParams))
            {
                self.id = id
                \(initCall)
            }
            
            // MARK: - query

            static func allowedOrders() -> [FieldKey] {
                [
                    \(allowedOrders)
                ]
            }
            
            static func defaultSort() -> FieldSort {
                .asc
            }
            
            static func search(_ term: String) -> [ModelValueFilter<FrontendPageModel>] {
                [
                    \(search)
                ]
            }
        }

        """
        
        return str
    }
    
    func createMigration(_ description: ModelDescription) -> String {
        let module = description.module.lowercased().capitalized
        let model = description.name.lowercased().capitalized
        
        
        let fields = description.fields.map { f in
            ".field(\(module)\(model)Model.FieldKeys.\(f.name), .\(f.type.rawValue)" + (f.isRequired ? ", .required" : "") + ")"
        }.joined(separator: "\n\t\t\t\t")
        
        let str = """
        //
        //  MenuEditForm.swift
        //  FrontendModule
        //
        //  Created by Tibor Bodecs on 2020. 11. 15..
        //

        struct \(module)Migration_v1: Migration {

            func prepare(on db: Database) -> EventLoopFuture<Void> {
                db.eventLoop.flatten([
                    
                    db.schema(\(module)\(model)Model.schema)
                        .id()
                        \(fields)
                        .create(),
                ])
            }

            func revert(on db: Database) -> EventLoopFuture<Void> {
                db.eventLoop.flatten([
                    db.schema(\(module)\(model)Model.schema).delete(),
                ])
            }
        }
        """
        
        return str
    }
    
    func createEditForm(_ description: ModelDescription) -> String {
        let module = description.module.lowercased().capitalized
        let model = description.name.lowercased().capitalized
        
        
        let fields = description.fields.map { f in
            var field = ""
            field += """
                \(f.formFieldType.rawValue.capitalized)Field(key: "\(f.name)")
                """
            if f.isRequired {
                field += """
                
                        .config { $0.output.required = true }"
                        .validators { [
                            FormFieldValidator($1, "\(f.name.capitalized) is required") { !$0.input.isEmpty },
                        ] }
                """
            }
            field += """
            
                        .read { $1.output.value = context.model?.\(f.name) }
                        .write { context.model?.\(f.name) = $1.input },
            """
            return field
        }.joined(separator: "\n\t\t\t\t")
        
        let str = """
        //
        //  MenuEditForm.swift
        //  FrontendModule
        //
        //  Created by Tibor Bodecs on 2020. 11. 15..
        //

        struct \(module)\(model)EditForm: FeatherForm {
            
            var context: FeatherFormContext<\(module)\(model)Model>
            
            init() {
                context = .init()
                context.form.fields = createFormFields()
            }

            private func createFormFields() -> [FormComponent] {
                [
                    \(fields)
                ]
            }
        }
        """
        
        return str
    }
    
    
    func createApi(_ description: ModelDescription) -> String {
        let module = description.module.lowercased().capitalized
        let model = description.name.lowercased().capitalized
        
        let listFields = description.fields.map { f in
            "\(f.name): \(f.swiftTypeValue)"
        }.joined(separator: "\n\t\t\t  ")
        
        let getFields = description.fields.map { f in
            "\(f.name): \(f.swiftTypeValue)"
        }.joined(separator: "\n\t\t\t  ")
        
        let createFields = description.fields.map { f in
            "\(f.name): \(f.swiftTypeValue)"
        }.joined(separator: "\n\t\t\t")
        
        let updateFields = description.fields.map { f in
            "\(f.name): \(f.swiftTypeValue)"
        }.joined(separator: "\n\t\t\t")
        
        let patchFields = description.fields.map { f in
            "\(f.name): \(f.swiftTypeValue)"
        }.joined(separator: "\n\t\t\t")
        
        let str = """
        //
        //  MenuEditForm.swift
        //  FrontendModule
        //
        //  Created by Tibor Bodecs on 2020. 11. 15..
        //

        extension \(model)ListObject: Content {}
        extension \(model)GetObject: Content {}
        extension \(model)CreateObject: Content {}
        extension \(model)UpdateObject: Content {}
        extension \(model)PatchObject: Content {}

        struct \(module)\(model)Api: FeatherApiRepresentable {
            typealias Model = \(module)\(model)Model

            typealias ListObject = \(model)ListObject
            typealias GetObject = \(model)GetObject
            typealias CreateObject = \(model)CreateObject
            typealias UpdateObject = \(model)UpdateObject
            typealias PatchObject = \(model)PatchObject
            
            func mapList(model: Model) -> ListObject {
                .init(id: model.id!,
                      \(listFields))
            }
            
            func mapGet(model: Model) -> GetObject {
                .init(id: model.id!,
                      \(getFields))
            }
            
            func mapCreate(model: Model, input: CreateObject) {
                
            }
            
            func mapUpdate(model: Model, input: UpdateObject) {
                
            }

            func mapPatch(model: Model, input: PatchObject) {
                
            }
            
            func validateCreate(_ req: Request) -> EventLoopFuture<Bool> {
                req.eventLoop.future(true)
            }
            
            func validateUpdate(_ req: Request) -> EventLoopFuture<Bool> {
                req.eventLoop.future(true)
            }
            
            func validatePatch(_ req: Request) -> EventLoopFuture<Bool> {
                req.eventLoop.future(true)
            }
        }
        """
        
        return str
    }
    
    
    func createListObject(_ description: ModelDescription) -> String {
        let module = description.module.lowercased().capitalized
        let model = description.name.lowercased().capitalized
        
        let props = description.fields.map { f in
            "public let \(f.name): \(f.swiftTypeValue)"
        }.joined(separator: "\n\t")
        
        let fields = description.fields.map { f in
            "\(f.name): \(f.swiftTypeValue)"
        }.joined(separator: "\n\t\t\t\t")
        
        let initFields = description.fields.map { f in
            "self.\(f.name) = \(f.name)"
        }.joined(separator: "\n\t\t")
        
       
        let str = """
            //
            //  MenuEditForm.swift
            //  FrontendModule
            //
            //  Created by Tibor Bodecs on 2020. 11. 15..
            //

            import Foundation

            public struct \(model)ListObject: Codable {

                public let id: UUID
                \(props)
                
                public init(id: UUID,
                            \(fields)) {
                    self.id = id
                    \(initFields)
                }
            }
        """
        
        return str
    }
    
    func createGetObject(_ description: ModelDescription) -> String {
        let module = description.module.lowercased().capitalized
        let model = description.name.lowercased().capitalized
        
        let props = description.fields.map { f in
            "public let \(f.name): \(f.swiftTypeValue)"
        }.joined(separator: "\n\t")
        
        let fields = description.fields.map { f in
            "\(f.name): \(f.swiftTypeValue)"
        }.joined(separator: "\n\t\t\t\t")
        
        let initFields = description.fields.map { f in
            "self.\(f.name) = \(f.name)"
        }.joined(separator: "\n\t\t")
        
       
        let str = """
        //
        //  MenuEditForm.swift
        //  FrontendModule
        //
        //  Created by Tibor Bodecs on 2020. 11. 15..
        //

        import Foundation

        public struct \(model)GetObject: Codable {

            public let id: UUID
            \(props)
            
            public init(id: UUID,
                        \(fields)) {
                self.id = id
                \(initFields)
            }
        }
        """
        
        return str
    }
    
    func createCreateObject(_ description: ModelDescription) -> String {
        let module = description.module.lowercased().capitalized
        let model = description.name.lowercased().capitalized
        
        let props = description.fields.map { f in
            "public let \(f.name): \(f.swiftTypeValue)"
        }.joined(separator: "\n\t")
        
        let fields = description.fields.map { f in
            "\(f.name): \(f.swiftTypeValue)"
        }.joined(separator: "\n\t\t\t\t")
        
        let initFields = description.fields.map { f in
            "self.\(f.name) = \(f.name)"
        }.joined(separator: "\n\t\t")
        
       
        let str = """
        //
        //  MenuEditForm.swift
        //  FrontendModule
        //
        //  Created by Tibor Bodecs on 2020. 11. 15..
        //

        import Foundation

        public struct \(model)CreateObject: Codable {

            \(props)
            
            public init(\(fields)) {
                \(initFields)
            }
        }
        """
        
        return str
    }
    
    func createUpdateObject(_ description: ModelDescription) -> String {
        let module = description.module.lowercased().capitalized
        let model = description.name.lowercased().capitalized
        
        let props = description.fields.map { f in
            "public let \(f.name): \(f.swiftTypeValue)"
        }.joined(separator: "\n\t")
        
        let fields = description.fields.map { f in
            "\(f.name): \(f.swiftTypeValue)"
        }.joined(separator: "\n\t\t\t\t")
        
        let initFields = description.fields.map { f in
            "self.\(f.name) = \(f.name)"
        }.joined(separator: "\n\t\t")
        
       
        let str = """
        //
        //  MenuEditForm.swift
        //  FrontendModule
        //
        //  Created by Tibor Bodecs on 2020. 11. 15..
        //

        import Foundation

        public struct \(model)UpdateObject: Codable {

            \(props)
            
            public init(\(fields)) {
                \(initFields)
            }
        }
        """
        
        return str
    }
    
    func createPatchObject(_ description: ModelDescription) -> String {
        let module = description.module.lowercased().capitalized
        let model = description.name.lowercased().capitalized
        
        let props = description.fields.map { f in
            "public let \(f.name): \(f.type.rawValue.capitalized)?"
        }.joined(separator: "\n\t")
        
        let fields = description.fields.map { f in
            "\(f.name): \(f.type.rawValue.capitalized)? = nil"
        }.joined(separator: "\n\t\t\t\t")
        
        let initFields = description.fields.map { f in
            "self.\(f.name) = \(f.name)"
        }.joined(separator: "\n\t\t")
        
       
        let str = """
        //
        //  MenuEditForm.swift
        //  FrontendModule
        //
        //  Created by Tibor Bodecs on 2020. 11. 15..
        //

        import Foundation

        public struct \(model)PatchObject: Codable {

            \(props)
            
            public init(\(fields)) {
                \(initFields)
            }
        }
        """
        
        return str
    }
    
   

}
