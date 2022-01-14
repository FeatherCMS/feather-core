//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//

import Foundation

public struct RouterGenerator {

    let descriptor: ModuleDescriptor
    
    public init(_ descriptor: ModuleDescriptor) {
        self.descriptor = descriptor
    }
    
    private func generateControllers(_ model: ModelDescriptor) -> String {
        """
        let \(model.name.lowercased())ApiController = \(descriptor.name)\(model.name)ApiController()
            let \(model.name.lowercased())AdminController = \(descriptor.name)\(model.name)AdminController()
        """
    }
    
    private func generateSetUpApiCall(_ model: ModelDescriptor) -> String {
        "\(model.name.lowercased())ApiController.setUpRoutes(args.routes)"
    }

    private func generateSetUpAdminCall(_ model: ModelDescriptor) -> String {
        "\(model.name.lowercased())AdminController.setUpRoutes(args.routes)"
    }
    
    private func generateNavigationLink(_ model: ModelDescriptor) -> String {
        """
            .init(label: "\(model.name)",
                      path: "/admin/\(descriptor.name.lowercased())/\(model.name.lowercased())/",
                      permission: \(descriptor.name).\(model.name).permission(for: .list).key),
        """
    }
    
    public func generate() -> String {

        let controllers = descriptor.models.map { generateControllers($0) }.joined(separator: "\n\n")
        let apiCalls = descriptor.models.map { generateSetUpApiCall($0) }.joined(separator: "\n")
        let adminCalls = descriptor.models.map { generateSetUpAdminCall($0) }.joined(separator: "\n")
        let navLinks = descriptor.models.map { generateNavigationLink($0) }.joined(separator: "\n\n")
        
        
        return """
        struct \(descriptor.name)Router: FeatherRouter {

            \(controllers)

            func apiRoutesHook(args: HookArguments) {
                \(apiCalls)
            }

            func adminRoutesHook(args: HookArguments) {
                \(adminCalls)

                args.routes.get("\(descriptor.name.lowercased())") { req -> Response in
                    let template = AdminModulePageTemplate(.init(title: "\(descriptor.name)",
                                                                 message: "module information",
                                                                 navigation: [
            \(navLinks)
                                                                 ]))
                    return req.templates.renderHtml(template)
                }
            }
            
        }
        """
    }
}
