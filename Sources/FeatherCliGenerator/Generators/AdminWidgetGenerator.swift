//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 09..
//

import Foundation

public struct AdminWidgetGenerator {

    let descriptor: ModuleDescriptor
    
    public init(_ descriptor: ModuleDescriptor) {
        self.descriptor = descriptor
    }
    
    func generateLink(_ model: ModelDescriptor) -> String {
        """
        if req.checkPermission(\(descriptor.name).\(model.name).permission(for: .list)) {
            Li {
                A("\(model.name)s")
                    .href("/admin/\(descriptor.name.lowercased())/\(model.name.lowercased())s/")
            }
        }
        """
    }
    
    public func generate() -> String {
        let links = descriptor.models.map { generateLink($0) }.joined(separator: "\n").indentLines(3)
        
        
        return """
        import SwiftHtml
        import FeatherIcons

        struct \(descriptor.name)AdminWidgetTemplate: TemplateRepresentable {
            
            @TagBuilder
            func render(_ req: Request) -> Tag {
                Svg.feather
                H2("\(descriptor.name)")
                Ul {
        \(links)
                }
            }
        }
        """
    }
}
