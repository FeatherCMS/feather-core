//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

struct SystemMetadataAdminController: AdminListController, AdminDetailController, AdminUpdateController {
    typealias ApiModel = FeatherMetadata
    typealias DatabaseModel = SystemMetadataModel
    
    typealias UpdateModelEditor = SystemMetadataEditor
    
    
    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            "title",
            "module",
            "model",
        ])
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<DatabaseModel>] {
        [
            \.$title ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init("title"),
//            .init("module"),
//            .init("model"),
        ]
    }
    
    func listCells(for model: DatabaseModel) -> [CellContext] {
        [
            .init(model.title, link: LinkContext(label: model.title ?? "Details", permission: FeatherMetadata.permission(for: .detail).key)),
//            .init(model.module),
//            .init(model.model),
        ]
    }
    
    func detailFields(for model: DatabaseModel) -> [DetailContext] {
        [
            .init("id", model.uuid.string),
//            .init("module", model.module),
//            .init("model", model.model),
//            .init("reference", model.reference.string),
            .init("slug", model.slug),
            .init("status", model.status.rawValue),
            .init("date", Feather.dateFormatter().string(from: model.date)),
            .init("title", model.title),
            .init("excerpt", model.excerpt),
            .init("image", model.imageKey, type: .image),
            .init("feed", model.feedItem ? "Yes" : "No", label: "Feed item?"),
            .init("canonical", model.canonicalUrl, label: "Canonical URL"),
            .init("css", model.css),
            .init("js", model.js),
            .init("filters", model.filters.joined(separator: "\n")),
        ]
    }
    
    // MARK: - metadata context
    
    func listNavigation(_ req: Request) -> [LinkContext] {
        []
    }

    func detailNavigation(_ req: Request, _ model: DatabaseModel) -> [LinkContext] {
        [
            LinkContext(label: "Update",
                        path: Self.updatePathComponent.description,
                        permission: nil), //Self.updatePermission()),
            // @NOTE: store permission for the metadata reference?
            LinkContext(label: "Preview",
                        path: model.slug.safePath(),
                        absolute: true,
                        isBlank: true),
            LinkContext(label: "Reference",
                        path: "/admin/" + model.module + "/" + model.model + "/" + model.reference.string + "/update/",
                        absolute: true,
                        permission: nil),
        ]
    }

    func updateNavigation(_ req: Request, _ model: DatabaseModel) -> [LinkContext] {
        [
            LinkContext(label: "Details",
                        dropLast: 1,
                        permission: nil), //Self.detailPermission()),
            LinkContext(label: "Preview",
                        path: model.slug.safePath(),
                        absolute: true,
                        isBlank: true),
            LinkContext(label: "Reference",
                        path: "/admin/" + model.module + "/" + model.model + "/" + model.reference.string + "/update/",
                        absolute: true,
                        permission: nil),
        ]
    }
}
