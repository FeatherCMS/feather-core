//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

extension Metadata: ViewContextRepresentable {

    public struct ViewContext: Encodable {
        var id: String
        
        var module: String
        var model: String
        var reference: String

        var slug: String
        var date: Date
        var status: String
        var title: String?
        var excerpt: String?
        var imageKey: String?
        var canonicalUrl: String?

        init(model: Metadata) {
            self.id = model.id!.uuidString
            self.module = model.module
            self.model = model.model
            self.reference = model.reference.uuidString
            
            self.slug = model.slug
            self.date = model.date
            self.status = model.status.rawValue
            self.title = model.title
            self.excerpt = model.excerpt
            self.imageKey = model.imageKey
            self.canonicalUrl = model.canonicalUrl
        }
    }

    public var viewContext: ViewContext { .init(model: self) }
    
    public var viewIdentifier: String { id!.uuidString }
}
