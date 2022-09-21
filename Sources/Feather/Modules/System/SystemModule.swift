//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor
import FeatherObjects

extension FeatherFile: Content {}

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
        
        app.hooks.registerAsync(.adminWidgetGroups, use: adminWidgetGroupsHook)
        
        try router.boot(app)
    }
    
    func config(_ app: Application) throws {
        try router.config(app)
    }
    
    func installHook(args: HookArguments) async throws {
        let permissions: [FeatherPermission.Create] = args.req.invokeAllFlat(.installPermissions)

        try await permissions.map {
            SystemPermissionModel(namespace: $0.namespace,
                                  context: $0.context,
                                  action: $0.action,
                                  name: $0.name,
                                  notes: $0.notes)
        }
        .create(on: args.req.db, chunks: 25)

        let variables: [FeatherVariable.Create] = args.req.invokeAllFlat(.installVariables)
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

    func installPermissionsHook(args: HookArguments) -> [FeatherPermission.Create] {
        var permissions = FeatherSystem.availablePermissions()
        permissions += FeatherPermission.availablePermissions()
        permissions += FeatherVariable.availablePermissions()
        permissions += FeatherMetadata.availablePermissions()
        permissions += FeatherFile.availablePermissions()
        return permissions.map { .init($0) }
    }
    
    func adminWidgetGroupsHook(args: HookArguments) async throws -> [WidgetGroup] {
        [
            .init(id: "system", title: "System", excerpt: "System group")
        ]
    }
    
    func adminWidgetsHook(args: HookArguments) -> [TemplateRepresentable] {
        guard
            let widgetGroup = args["widgetGroup"] as? WidgetGroup,
            widgetGroup.id == "system"
        else {
            return []
        }
        return [
            SystemAdminWidgetTemplate()
        ]
    }
    
    func installSystemVariablesHook(args: HookArguments) -> [FeatherVariable.Create] {
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
  
            .init(key: "systemEmailAddress",
                  name: "Sender address for general email messages",
                  value: "noreply@feathercms.com",
                  notes: """
                        This mail address is going to be used as a sender address for system mails.
                    """),
        ]
    }
    
}

