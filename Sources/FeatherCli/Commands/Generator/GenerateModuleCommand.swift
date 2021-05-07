//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 21..
//

struct GenerateModuleCommand: Command {
    
    static let name = "module"
        
    struct Signature: CommandSignature {}

    let help = "This command will generate a Feather module."

    func run(using context: CommandContext, signature: Signature) throws {
        let moduleName = context.console.ask("Module name?").uppercasedFirst
        var models: [ModelDescription] = []
        var addNextModel = false
        repeat {
            let modelName = context.console.ask("Model name?").uppercasedFirst
            var properties: [PropertyDescription] = []
            var addNextProperty = false
            repeat {
                let name = context.console.ask("Property name (field)?")
                let type = PropertyDescription.FieldType(rawValue: context.console.choose("Select a type", from: PropertyDescription.FieldType.allCases.map(\.rawValue)))!
                let isRequired = context.console.choose("Is required?", from: ["Yes", "No"]) == "Yes"
                var searchable = false
                if type == .string {
                    searchable = context.console.choose("Searchable?", from: ["Yes", "No"]) == "Yes"
                }
                let orderabe = context.console.choose("Ordering is allowed?", from: ["Yes", "No"]) == "Yes"
                let view = PropertyDescription.FormFieldType(rawValue: context.console.choose("Form field type", from: PropertyDescription.FormFieldType.allCases.map(\.rawValue)))!
                
                let property = PropertyDescription(name: name,
                                             type: type,
                                             isRequired: isRequired,
                                             isSearchable: searchable,
                                             isOrderingAllowed: orderabe,
                                             formFieldType: view)
                
                properties.append(property)
                console.info("Field created...")
                addNextProperty = context.console.choose("Add another property?", from: ["Yes", "No"]) == "Yes"
            }
            while addNextProperty

            models.append(ModelDescription(name: modelName, properties: properties))
            console.info("Model created...")
            addNextModel = context.console.choose("Add another model?", from: ["Yes", "No"]) == "Yes"
        }
        while addNextModel
        
        let desc = ModuleDescription(name: moduleName, author: getGitUser(), date: Date(), models: models)
        try generateModule(desc)
    }
    
    // MARK: - helpers
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "y. MM. d."
        return formatter
    }()
    
    func getGitUser() -> String {
        let task = Process()
        task.launchPath = "/bin/bash/"
        task.arguments = ["-c", "git config user.name"]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8) else {
            return ""
        }
        return output.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func copy(file: String, module: String, author: String, date: Date = .init()) -> String {
        return """
        //
        //  \(file).swift
        //  \(module)Module
        //
        //  Created by \(author) on \(formatter.string(from: date)).
        //
        
        import FeatherCore
        """
    }
    
    // MARK: - generators
    
    func generateModule(_ module: ModuleDescription) throws {
        //        let path = CommandLine.arguments[0]
        let path = "/Users/tib/"
        
        let url = URL(fileURLWithPath: path)
        let moduleUrl = url.appendingPathComponent(module.name)
        
        let apisUrl = moduleUrl.appendingPathComponent("Apis")
        let controllersUrl = moduleUrl.appendingPathComponent("Controllers")
        let formsUrl = moduleUrl.appendingPathComponent("Forms")
        let migrationsUrl = moduleUrl.appendingPathComponent("Migrations")
        let modelsUrl = moduleUrl.appendingPathComponent("Models")

        if FileManager.default.fileExists(atPath: moduleUrl.path) {
            try FileManager.default.removeItem(at: moduleUrl)
        }
        
        try FileManager.default.createDirectory(at: moduleUrl, withIntermediateDirectories: true, attributes: nil)
        
        try FileManager.default.createDirectory(at: apisUrl, withIntermediateDirectories: true, attributes: nil)
        try FileManager.default.createDirectory(at: controllersUrl, withIntermediateDirectories: true, attributes: nil)
        try FileManager.default.createDirectory(at: formsUrl, withIntermediateDirectories: true, attributes: nil)
        try FileManager.default.createDirectory(at: migrationsUrl, withIntermediateDirectories: true, attributes: nil)
        try FileManager.default.createDirectory(at: modelsUrl, withIntermediateDirectories: true, attributes: nil)
        
        let moduleFile = moduleUrl.appendingPathComponent("\(module.name)Module.swift")
        try generateModuleFile(module).write(toFile: moduleFile.path, atomically: true, encoding: .utf8)
        
//        let model = createModel(description)
//        let migration = createMigration(description)
//        let editForm = createEditForm(description)
//        let api = createApi(description)
//
//        let listObject = createListObject(description)
//        let getObject = createGetObject(description)
//        let createObject = createCreateObject(description)
//        let updateObject = createUpdateObject(description)
//        let patchObject = createPatchObject(description)
//
//        try model.write(toFile: path + "\(moduleName)\(modelName)Model.swift", atomically: true, encoding: .utf8)
//        try migration.write(toFile: path + "\(moduleName)Migration_v1.swift", atomically: true, encoding: .utf8)
//        try editForm.write(toFile: path + "\(moduleName)\(modelName)EditForm.swift", atomically: true, encoding: .utf8)
//        try api.write(toFile: path + "\(moduleName)\(modelName)Api.swift", atomically: true, encoding: .utf8)
//
//        try listObject.write(toFile: path + "\(modelName)ListObject.swift", atomically: true, encoding: .utf8)
//        try getObject.write(toFile: path + "\(modelName)GetObject.swift", atomically: true, encoding: .utf8)
//        try createObject.write(toFile: path + "\(modelName)CreateObject.swift", atomically: true, encoding: .utf8)
//        try updateObject.write(toFile: path + "\(modelName)UpdateObject.swift", atomically: true, encoding: .utf8)
//        try patchObject.write(toFile: path + "\(modelName)PatchObject.swift", atomically: true, encoding: .utf8)
    }
    
    // MARK: - generator helpers
    
    func generateModuleFile(_ module: ModuleDescription) -> String {
        let menuItems = module.models.map { model in
            ".init(link: \(module.name)\(model.name)Model.adminLink, permission: \(module.name)\(model.name)Model.permission(for: .list).identifier),"
        }.joined(separator: "\n\t\t\t")
        
        return """
            \(copy(file: "\(module.name)Module", module: module.name, author: module.author))

            final class \(module.name)Module: FeatherModule {

                static var moduleKey: String = "\(module.key)"

                func boot(_ app: Application) throws {
                    /// database
                    app.migrations.add(\(module.name)Migration_v1())

                    /// install
                    app.hooks.register(.installPermissions, use: installPermissionsHook)
                    /// admin menus
                    app.hooks.register(.adminMenu, use: adminMenuHook)
                    /// routes
                    let router = \(module.name)Router()
                    try router.boot(routes: app.routes)
                    app.hooks.register(.routes, use: router.routesHook)
                    app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
                    app.hooks.register(.apiRoutes, use: router.apiRoutesHook)
                    app.hooks.register(.apiAdminRoutes, use: router.apiAdminRoutesHook)
                }
              
                // MARK: - hooks

                func adminMenuHook(args: HookArguments) -> HookObjects.AdminMenu {
                    .init(key: "\(module.key)",
                          item: .init(icon: "\(module.key)", link: Self.adminLink, permission: Self.permission(for: .custom("admin")).identifier),
                          children: [
                            \(menuItems)
                          ])
                }
            
            """
    }

    func generateRouterFile(_ description: ModuleDescription) -> String {
        """
        //
        //  File.swift
        //
        //
        //  Created by Tibor Bodecs on 2021. 04. 21..
        //


        struct FrontendRouter: RouteCollection {

            let frontendController = FrontendWebController()
            var metadataController = FrontendMetadataController()
            let menuController = FrontendMenuController()
            let menuItemController = FrontendMenuItemController()
            let pageController = FrontendPageController()

            func boot(routes: RoutesBuilder) throws {
                routes.get("sitemap.xml", use: frontendController.sitemap)
                routes.get("rss.xml", use: frontendController.rss)
                routes.get("robots.txt", use: frontendController.robots)
            }
            
            func routesHook(args: HookArguments) {
                let app = args.app
                let routes = args.routes
                /// if there are other middlewares we add them, finally we append the not found middleware
                let middlewares: [[Middleware]] = app.invokeAll(.webMiddlewares)
                var frontendMiddlewares = middlewares.flatMap { $0 }
                frontendMiddlewares.append(UserAccountSessionAuthenticator())
                frontendMiddlewares.append(FrontendErrorMiddleware())
                let frontendRoutes = routes.grouped(frontendMiddlewares)
                
                var webArgs = HookArguments()
                webArgs.routes = frontendRoutes
                let _: [Void] = app.invokeAll(.frontendRoutes, args: webArgs)
                
                /// handle root path and everything else via the controller method
                frontendRoutes.get(use: frontendController.catchAllView)
                frontendRoutes.get(.catchall, use: frontendController.catchAllView)
            }

            func adminRoutesHook(args: HookArguments) {
                let adminRoutes = args.routes

                adminRoutes.get("frontend", use: SystemAdminMenuController(key: "frontend").moduleView)
                
                adminRoutes.register(pageController)
                adminRoutes.register(metadataController)
                adminRoutes.register(menuController)
                adminRoutes.register(menuItemController)
            }
            
            func apiRoutesHook(args: HookArguments) {
        //        let publicApiRoutes = args.routes
            }

            func apiAdminRoutesHook(args: HookArguments) {
                let apiRoutes = args.routes

                apiRoutes.registerApi(pageController)
                apiRoutes.registerApi(metadataController)
                apiRoutes.registerApi(menuController)
                apiRoutes.registerApi(menuItemController)
            }
        }

        """
    }
    
    func generateInstallFile(_ description: ModuleDescription) -> String {
        """
        
        extension FrontendModule {
            func installPermissionsHook(args: HookArguments) -> [PermissionCreateObject] {
                var permissions: [PermissionCreateObject] = [
                    FrontendModule.hookInstallPermission(for: .custom("admin"))
                ]
                permissions += FrontendMetadataModel.hookInstallPermissions()
                permissions += FrontendMenuModel.hookInstallPermissions()
                permissions += FrontendMenuItemModel.hookInstallPermissions()
                permissions += FrontendPageModel.hookInstallPermissions()
                return permissions
            }
        }
        """
    }

//    func createModel(_ description: ModelDescription) -> String {
//        let module = description.module.uppercasedFirst
//        let model = description.name.uppercasedFirst
//
//
//        let fieldKeys = description.fields.map { f in
//            "static var \(f.name): FieldKey { \"\(f.name)\" }"
//        }.joined(separator: "\n\t\t")
//
//        let fields = description.fields.map { f in
//            "@Field(key: FieldKeys.\(f.name) var \(f.name): \(f.swiftTypeValue)"
//        }.joined(separator: "\n\t")
//
//        let initParams = description.fields.map { f in
//            "\(f.name): \(f.swiftTypeValue)"
//        }.joined(separator: "\n\t\t")
//
//        let initCall = description.fields.map { f in
//            "self.\(f.name) = \(f.name)"
//        }.joined(separator: "\n\t\t ")
//
//        let allowedOrders = description.fields.filter(\.isOrderingAllowed).map { f in
//            "FieldKeys.\(f.name)"
//        }.joined(separator: "\n\t\t\t")
//
//        let search = description.fields.filter(\.isSearchable).map { f in
//            "\\.$\(f.name) ~~ term"
//        }.joined(separator: "\n\t\t\t")
//
//        let str = """
//        //
//        //  MenuEditForm.swift
//        //  FrontendModule
//        //
//        //  Created by Tibor Bodecs on 2020. 11. 15..
//        //
//
//        final class \(module)\(model)Model: FeatherModel {
//            typealias Module = \(module)Module
//
//            static let modelKey: String = "\(model.lowercased())s"
//            static let name: FeatherModelName = "\(model)"
//
//            struct FieldKeys {
//                \(fieldKeys)
//            }
//
//            // MARK: - fields
//
//            @ID() var id: UUID?
//            \(fields)
//
//            init() { }
//
//            init(id: UUID? = nil,
//                 \(initParams))
//            {
//                self.id = id
//                \(initCall)
//            }
//
//            // MARK: - query
//
//            static func allowedOrders() -> [FieldKey] {
//                [
//                    \(allowedOrders)
//                ]
//            }
//
//            static func defaultSort() -> FieldSort {
//                .asc
//            }
//
//            static func search(_ term: String) -> [ModelValueFilter<FrontendPageModel>] {
//                [
//                    \(search)
//                ]
//            }
//        }
//
//        """
//
//        return str
//    }
//
//    func createMigration(_ description: ModelDescription) -> String {
//        let module = description.module.uppercasedFirst
//        let model = description.name.uppercasedFirst
//
//
//        let fields = description.fields.map { f in
//            ".field(\(module)\(model)Model.FieldKeys.\(f.name), .\(f.type.rawValue)" + (f.isRequired ? ", .required" : "") + ")"
//        }.joined(separator: "\n\t\t\t\t")
//
//        let str = """
//        //
//        //  MenuEditForm.swift
//        //  FrontendModule
//        //
//        //  Created by Tibor Bodecs on 2020. 11. 15..
//        //
//
//        struct \(module)Migration_v1: Migration {
//
//            func prepare(on db: Database) -> EventLoopFuture<Void> {
//                db.eventLoop.flatten([
//
//                    db.schema(\(module)\(model)Model.schema)
//                        .id()
//                        \(fields)
//                        .create(),
//                ])
//            }
//
//            func revert(on db: Database) -> EventLoopFuture<Void> {
//                db.eventLoop.flatten([
//                    db.schema(\(module)\(model)Model.schema).delete(),
//                ])
//            }
//        }
//        """
//
//        return str
//    }
//
//    func createEditForm(_ description: ModelDescription) -> String {
//        let module = description.module.uppercasedFirst
//        let model = description.name.uppercasedFirst
//
//
//        let fields = description.fields.map { f in
//            var field = ""
//            field += """
//                \(f.formFieldType.rawValue.capitalized)Field(key: "\(f.name)")
//                """
//            if f.isRequired {
//                field += """
//
//                        .config { $0.output.required = true }"
//                        .validators { [
//                            FormFieldValidator($1, "\(f.name.capitalized) is required") { !$0.input.isEmpty },
//                        ] }
//                """
//            }
//            field += """
//
//                        .read { $1.output.value = context.model?.\(f.name) }
//                        .write { context.model?.\(f.name) = $1.input },
//            """
//            return field
//        }.joined(separator: "\n\t\t\t\t")
//
//        let str = """
//        //
//        //  MenuEditForm.swift
//        //  FrontendModule
//        //
//        //  Created by Tibor Bodecs on 2020. 11. 15..
//        //
//
//        struct \(module)\(model)EditForm: FeatherForm {
//
//            var context: FeatherFormContext<\(module)\(model)Model>
//
//            init() {
//                context = .init()
//                context.form.fields = createFormFields()
//            }
//
//            private func createFormFields() -> [FormComponent] {
//                [
//                    \(fields)
//                ]
//            }
//        }
//        """
//
//        return str
//    }
//
//
//    func createApi(_ description: ModelDescription) -> String {
//        let module = description.module.uppercasedFirst
//        let model = description.name.uppercasedFirst
//
//        let listFields = description.fields.map { f in
//            "\(f.name): \(f.swiftTypeValue)"
//        }.joined(separator: "\n\t\t\t  ")
//
//        let getFields = description.fields.map { f in
//            "\(f.name): \(f.swiftTypeValue)"
//        }.joined(separator: "\n\t\t\t  ")
//
//        let createFields = description.fields.map { f in
//            "\(f.name): \(f.swiftTypeValue)"
//        }.joined(separator: "\n\t\t\t")
//
//        let updateFields = description.fields.map { f in
//            "\(f.name): \(f.swiftTypeValue)"
//        }.joined(separator: "\n\t\t\t")
//
//        let patchFields = description.fields.map { f in
//            "\(f.name): \(f.swiftTypeValue)"
//        }.joined(separator: "\n\t\t\t")
//
//        let str = """
//        //
//        //  MenuEditForm.swift
//        //  FrontendModule
//        //
//        //  Created by Tibor Bodecs on 2020. 11. 15..
//        //
//
//        extension \(model)ListObject: Content {}
//        extension \(model)GetObject: Content {}
//        extension \(model)CreateObject: Content {}
//        extension \(model)UpdateObject: Content {}
//        extension \(model)PatchObject: Content {}
//
//        struct \(module)\(model)Api: FeatherApiRepresentable {
//            typealias Model = \(module)\(model)Model
//
//            typealias ListObject = \(model)ListObject
//            typealias GetObject = \(model)GetObject
//            typealias CreateObject = \(model)CreateObject
//            typealias UpdateObject = \(model)UpdateObject
//            typealias PatchObject = \(model)PatchObject
//
//            func mapList(model: Model) -> ListObject {
//                .init(id: model.id!,
//                      \(listFields))
//            }
//
//            func mapGet(model: Model) -> GetObject {
//                .init(id: model.id!,
//                      \(getFields))
//            }
//
//            func mapCreate(model: Model, input: CreateObject) {
//
//            }
//
//            func mapUpdate(model: Model, input: UpdateObject) {
//
//            }
//
//            func mapPatch(model: Model, input: PatchObject) {
//
//            }
//
//            func validateCreate(_ req: Request) -> EventLoopFuture<Bool> {
//                req.eventLoop.future(true)
//            }
//
//            func validateUpdate(_ req: Request) -> EventLoopFuture<Bool> {
//                req.eventLoop.future(true)
//            }
//
//            func validatePatch(_ req: Request) -> EventLoopFuture<Bool> {
//                req.eventLoop.future(true)
//            }
//        }
//        """
//
//        return str
//    }
//
//
//    func createListObject(_ description: ModelDescription) -> String {
//        let module = description.module.uppercasedFirst
//        let model = description.name.uppercasedFirst
//
//        let props = description.fields.map { f in
//            "public let \(f.name): \(f.swiftTypeValue)"
//        }.joined(separator: "\n\t")
//
//        let fields = description.fields.map { f in
//            "\(f.name): \(f.swiftTypeValue)"
//        }.joined(separator: "\n\t\t\t\t")
//
//        let initFields = description.fields.map { f in
//            "self.\(f.name) = \(f.name)"
//        }.joined(separator: "\n\t\t")
//
//
//        let str = """
//            //
//            //  MenuEditForm.swift
//            //  FrontendModule
//            //
//            //  Created by Tibor Bodecs on 2020. 11. 15..
//            //
//
//            import Foundation
//
//            public struct \(model)ListObject: Codable {
//
//                public let id: UUID
//                \(props)
//
//                public init(id: UUID,
//                            \(fields)) {
//                    self.id = id
//                    \(initFields)
//                }
//            }
//        """
//
//        return str
//    }
//
//    func createGetObject(_ description: ModelDescription) -> String {
//        let module = description.module.uppercasedFirst
//        let model = description.name.uppercasedFirst
//
//        let props = description.fields.map { f in
//            "public let \(f.name): \(f.swiftTypeValue)"
//        }.joined(separator: "\n\t")
//
//        let fields = description.fields.map { f in
//            "\(f.name): \(f.swiftTypeValue)"
//        }.joined(separator: "\n\t\t\t\t")
//
//        let initFields = description.fields.map { f in
//            "self.\(f.name) = \(f.name)"
//        }.joined(separator: "\n\t\t")
//
//
//        let str = """
//        //
//        //  MenuEditForm.swift
//        //  FrontendModule
//        //
//        //  Created by Tibor Bodecs on 2020. 11. 15..
//        //
//
//        import Foundation
//
//        public struct \(model)GetObject: Codable {
//
//            public let id: UUID
//            \(props)
//
//            public init(id: UUID,
//                        \(fields)) {
//                self.id = id
//                \(initFields)
//            }
//        }
//        """
//
//        return str
//    }
//
//    func createCreateObject(_ description: ModelDescription) -> String {
//        let module = description.module.uppercasedFirst
//        let model = description.name.uppercasedFirst
//
//        let props = description.fields.map { f in
//            "public let \(f.name): \(f.swiftTypeValue)"
//        }.joined(separator: "\n\t")
//
//        let fields = description.fields.map { f in
//            "\(f.name): \(f.swiftTypeValue)"
//        }.joined(separator: "\n\t\t\t\t")
//
//        let initFields = description.fields.map { f in
//            "self.\(f.name) = \(f.name)"
//        }.joined(separator: "\n\t\t")
//
//
//        let str = """
//        //
//        //  MenuEditForm.swift
//        //  FrontendModule
//        //
//        //  Created by Tibor Bodecs on 2020. 11. 15..
//        //
//
//        import Foundation
//
//        public struct \(model)CreateObject: Codable {
//
//            \(props)
//
//            public init(\(fields)) {
//                \(initFields)
//            }
//        }
//        """
//
//        return str
//    }
//
//    func createUpdateObject(_ description: ModelDescription) -> String {
//        let module = description.module.uppercasedFirst
//        let model = description.name.uppercasedFirst
//
//        let props = description.fields.map { f in
//            "public let \(f.name): \(f.swiftTypeValue)"
//        }.joined(separator: "\n\t")
//
//        let fields = description.fields.map { f in
//            "\(f.name): \(f.swiftTypeValue)"
//        }.joined(separator: "\n\t\t\t\t")
//
//        let initFields = description.fields.map { f in
//            "self.\(f.name) = \(f.name)"
//        }.joined(separator: "\n\t\t")
//
//
//        let str = """
//        //
//        //  MenuEditForm.swift
//        //  FrontendModule
//        //
//        //  Created by Tibor Bodecs on 2020. 11. 15..
//        //
//
//        import Foundation
//
//        public struct \(model)UpdateObject: Codable {
//
//            \(props)
//
//            public init(\(fields)) {
//                \(initFields)
//            }
//        }
//        """
//
//        return str
//    }
//
//    func createPatchObject(_ description: ModelDescription) -> String {
//        let module = description.module.uppercasedFirst
//        let model = description.name.uppercasedFirst
//
//        let props = description.fields.map { f in
//            "public let \(f.name): \(f.type.rawValue.capitalized)?"
//        }.joined(separator: "\n\t")
//
//        let fields = description.fields.map { f in
//            "\(f.name): \(f.type.rawValue.capitalized)? = nil"
//        }.joined(separator: "\n\t\t\t\t")
//
//        let initFields = description.fields.map { f in
//            "self.\(f.name) = \(f.name)"
//        }.joined(separator: "\n\t\t")
//
//
//        let str = """
//        //
//        //  MenuEditForm.swift
//        //  FrontendModule
//        //
//        //  Created by Tibor Bodecs on 2020. 11. 15..
//        //
//
//        import Foundation
//
//        public struct \(model)PatchObject: Codable {
//
//            \(props)
//
//            public init(\(fields)) {
//                \(initFields)
//            }
//        }
//        """
//
//        return str
//    }
    
   

}
