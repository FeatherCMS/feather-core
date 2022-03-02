//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//

import Foundation

public struct ModuleGenerator {
    
    let descriptor: ModuleDescriptor
    
    public init(_ descriptor: ModuleDescriptor) {
        self.descriptor = descriptor
    }
    
    public func generate() -> String {
        """
        public extension HookName {

        }

        struct \(descriptor.name)Module: FeatherModule {
            let router = \(descriptor.name)Router()

            func boot(_ app: Application) throws {
                app.migrations.add(\(descriptor.name)Migrations.v1())

                app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
                app.hooks.register(.adminWidgets, use: adminWidgetsHook)
                app.hooks.register(.apiRoutes, use: router.apiRoutesHook)
                app.hooks.register(.installUserPermissions, use: installUserPermissionsHook)
                
                try router.boot(app)
            }
            
            // MARK: - install
                
            func installUserPermissionsHook(args: HookArguments) -> [User.Permission.Create] {
                var permissions = \(descriptor.name).availablePermissions()
                \(generateModelPermissions())
                return permissions.map { .init($0) }
            }
        
            func adminWidgetsHook(args: HookArguments) -> [OrderedHookResult<TemplateRepresentable>] {
                if args.req.checkPermission(\(descriptor.name).permission(for: .detail)) {
                    return [
                        .init(\(descriptor.name)AdminWidgetTemplate(), order: 100),
                    ]
                }
                return []
            }
        }
        """
    }

    private func generateModelPermission(_ name: String) -> String {
        "permissions += \(descriptor.name).\(name).availablePermissions()"
    }

    private func generateModelPermissions() -> String {
        descriptor.models.map { generateModelPermission($0.name) }.joined(separator: "\n    ")
    }
}
