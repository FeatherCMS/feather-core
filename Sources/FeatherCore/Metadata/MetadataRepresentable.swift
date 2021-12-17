//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Foundation
import Vapor
import FeatherCoreApi

public protocol MetadataRepresentable: FeatherModel {

    var metadata: FeatherMetadata { get }
}


public extension AdminController where Model: MetadataRepresentable {
    
    func detailContext(_ req: Request, _ model: Model) -> AdminDetailPageContext {
        .init(title: Self.modelName.singular.uppercasedFirst + " details",
              fields: detailFields(for: model),
              breadcrumbs: [
                    Self.moduleLink(Self.moduleName.uppercasedFirst),
                    Self.listLink(Self.modelName.plural.uppercasedFirst),
              ],
              links: [
                    Self.updateLink(id: model.uuid),
                    .init(label: "Preview", url: model.joinedMetadata!.slug!.safePath(), isBlank: true),
                    WebMetadataController.updateLink("Metadata", id: model.joinedMetadata!.id!),
              ],
              actions: [
                    Self.deleteLink(id: model.uuid),
              ])
    }
    
    func updateContext(_ req: Request, _ editor: UpdateModelEditor) async -> AdminEditorPageContext {
        // TODO: error management...
        let metadata = try! await Model.findMetadata(reference: editor.model.uuid, on: req.db)!
        return .init(title: "Update " + Self.modelName.singular,
              form: editor.form.context(req),
              breadcrumbs: [
                    Self.moduleLink(Self.moduleName.uppercasedFirst),
                    Self.listLink(Self.modelName.plural.uppercasedFirst),
              ],
              links: [
                    Self.detailLink(id: editor.model.uuid),
                    .init(label: "Preview", url: metadata.slug!.safePath(), isBlank: true),
                    WebMetadataController.updateLink("Metadata", id: metadata.id!),
              ],
              actions: [
                    Self.deleteLink(id: editor.model.uuid),
              ])
    }
}

