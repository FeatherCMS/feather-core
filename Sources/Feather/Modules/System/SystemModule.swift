//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

struct SystemModule: FeatherModule {
    
    let router = SystemRouter()
    
    var template: SystemModuleTemplate
    
    init(template: SystemModuleTemplate) {
        self.template = template
    }

    func boot(_ app: Application) throws {
        app.templateEngine.register(template)

        app.migrations.add(SystemMigrations.v1())
        
        app.hooks.register(.routes, use: router.routesHook)
        app.hooks.registerAsync(.install, use: installHook, priority: 1000)
        app.hooks.registerAsync(.installResponse, use: installResponseHook)
        app.hooks.register(.installPermissions, use: installPermissionsHook)
        app.hooks.register(.adminWidgets, use: adminWidgetsHook, priority: 1000)
        app.hooks.register(.installVariables, use: installSystemVariablesHook)
        
        try router.boot(app)
    }
    
    func config(_ app: Application) throws {
        try router.config(app)
    }
    
    func installHook(args: HookArguments) async throws {
        let permissions: [System.Permission.Create] = args.req.invokeAllFlat(.installPermissions)

        try await permissions.map {
            SystemPermissionModel(namespace: $0.namespace,
                                  context: $0.context,
                                  action: $0.action,
                                  name: $0.name,
                                  notes: $0.notes)
        }
        .create(on: args.req.db, chunks: 25)

        let variables: [System.Variable.Create] = args.req.invokeAllFlat(.installVariables)
        try await variables.map {
            SystemVariableModel(key: $0.key,
                                name: $0.name,
                                value: $0.value,
                                notes: $0.notes)
        }
        .create(on: args.req.db, chunks: 25)
    }
    
    func installResponseHook(args: HookArguments) async throws -> Response? {
        let info = args.installInfo
        if info.currentStep == SystemInstallStep.start.key {
            return try await SystemStartInstallStepController().handleInstallStep(args.req, info: info)
        }
        if info.currentStep == SystemInstallStep.finish.key {
            return try await SystemFinishInstallStepController().handleInstallStep(args.req, info: info)
        }
        return nil
    }

    func installPermissionsHook(args: HookArguments) -> [System.Permission.Create] {
        var permissions = System.availablePermissions()
        permissions += System.Permission.availablePermissions()
        permissions += System.Variable.availablePermissions()
        permissions += System.Metadata.availablePermissions()
        return permissions.map { .init($0) }
    }
    
    func adminWidgetsHook(args: HookArguments) -> [TemplateRepresentable] {
        [
            SystemAdminWidgetTemplate()
        ]
    }
    
    func installSystemVariablesHook(args: HookArguments) -> [System.Variable.Create] {
        [
            .init(key: "systemDeepLinkScheme",
                  name: "Deep linking URL scheme for client apps",
                  value: "feathercms",
                  notes: """
                        Deep linking URL scheme for client apps
                        The value of this field only contains the scheme (e.g. feathercms)
                        The final URL can be constructed should be constructed using the scheme:
                        e.g. feathercms://[other-url-parts]
                    """),
        ]
    }
    
}

