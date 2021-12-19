//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

import Vapor
import Fluent
import SwiftHtml

public enum FieldSort: String, Codable, CaseIterable {
    case asc
    case desc
    
    public var direction: DatabaseQuery.Sort.Direction {
        switch self {
        case .asc:
            return .ascending
        case .desc:
            return .descending
        }
    }
}

public struct ListContainer<T>: Codable where T: Codable {

    public let items: [T]
    public let info: PaginationContext

    public init(_ items: [T], info: PaginationContext) {
        self.items = items
        self.info = info
    }
}

/// for API purposes
extension ListContainer: Content {}
extension PaginationContext: Content {}

public struct ListConfiguration {

    public let orderKey: String
    public let sortKey: String
    public let searchKey: String
    public let limitKey: String
    public let pageKey: String
    public let defaultLimit: Int
    public let defaultPage: Int
    public let allowedOrders: [FieldKey]
    public let defaultSort: FieldSort
    public let isSearchable: Bool

    public init(orderKey: String = "order",
                sortKey: String = "sort",
                searchKey: String = "search",
                limitKey: String = "limit",
                pageKey: String = "page",
                defaultLimit: Int = Feather.config.listLimit,
                defaultPage: Int = 1,
                allowedOrders: [FieldKey] = [],
                defaultSort: FieldSort = .asc,
                isSearchable: Bool = true) {
        self.orderKey = orderKey
        self.sortKey = sortKey
        self.searchKey = searchKey
        self.limitKey = limitKey
        self.pageKey = pageKey
        self.defaultLimit = defaultLimit
        self.defaultPage = defaultPage
        self.allowedOrders = allowedOrders
        self.defaultSort = defaultSort
        self.isSearchable = isSearchable
    }
}

public protocol ListController: ModelController {
    associatedtype ListModelApi: ListApi
    
    var listConfig: ListConfiguration { get }
    
    static func listPermission() -> UserPermission
    static func listPermission() -> String
    static func hasListPermission(_ req: Request) -> Bool

    func listQuery(_ req: Request, _ qb: QueryBuilder<Model>) -> QueryBuilder<Model>
    func listSort(_ req: Request,
                  _ qb: QueryBuilder<Model>,
                  _ order: FieldKey,
                  _ direction: DatabaseQuery.Sort.Direction) -> QueryBuilder<Model>
    func listSearch(_ term: String) -> [ModelValueFilter<Model>]
    func listTemplate(_ req: Request, _ list: ListContainer<Model>) -> TemplateRepresentable
    func listAccess(_ req: Request) async throws -> Bool
    func listView(_ req: Request) async throws -> Response
    func listApi(_ req: Request) async throws -> ListContainer<ListModelApi.ListObject> 
}

public extension ListController {

    var listConfig: ListConfiguration { .init() }

    func listSearch(_ term: String) -> [ModelValueFilter<Model>] {
        []
    }
    
    static func listPermission() -> UserPermission {
        Model.permission(.list)
    }
    
    static func listPermission() -> String {
        listPermission().key
    }
    
    static func hasListPermission(_ req: Request) -> Bool {
        req.checkPermission(listPermission())
    }
    
    func listAccess(_ req: Request) async throws -> Bool {
        try await req.checkAccess(for: Self.listPermission())
    }

    func listApi(_ req: Request) async throws -> ListContainer<ListModelApi.ListObject> {
        let hasAccess = try await listAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let api = ListModelApi()
        let list = try await list(req)
        let newItems = try await list.items.mapAsync { item in
            try await api.mapList(req, model: item as! ListModelApi.Model)
        }
        return ListContainer<ListModelApi.ListObject>.init(newItems, info: list.info)
    }

    func listView(_ req: Request) async throws -> Response {
        let hasAccess = try await listAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let list = try await list(req)
        return req.html.render(listTemplate(req, list))
    }
    
    func listQuery(_ req: Request, _ qb: QueryBuilder<Model>) -> QueryBuilder<Model> {
        qb
    }
    
    func listSort(_ req: Request,
                  _ qb: QueryBuilder<Model>,
                  _ order: FieldKey,
                  _ direction: DatabaseQuery.Sort.Direction) -> QueryBuilder<Model> {
        qb.sort(order, direction)
    }
}

private extension ListController {

    func list(_ req: Request) async throws -> ListContainer<Model> {
        let config = listConfig
        let listLimit: Int = max(req.query[config.limitKey] ?? config.defaultLimit, 1)
        let listPage: Int = max(req.query[config.pageKey] ?? config.defaultPage, 1)
        var qb = listQuery(req, Model.query(on: req.db))

        let allowedOrders = config.allowedOrders
        var fieldOrder = allowedOrders.first
        if !allowedOrders.isEmpty, let rawOrder: String = req.query[config.orderKey], allowedOrders.contains(.string(rawOrder)) {
            fieldOrder = .string(rawOrder)
        }

        var fieldSort: FieldSort = config.defaultSort
        if let rawSort: String = req.query[config.sortKey], let sortValue = FieldSort(rawValue: rawSort) {
            fieldSort = sortValue
        }

        if let order = fieldOrder {
            qb = listSort(req, qb, order, fieldSort.direction)
        }

        // search by terms
        if let term: String = req.query[config.searchKey], !term.isEmpty {
            qb = qb.group(.or) { qb in
                for v in listSearch(term) {
                    qb.filter(v)
                }
            }
        }
        return try await qb.paginate(limit: listLimit, page: listPage)
    }
}

public extension ListController where Model: MetadataRepresentable {
    
    func listSort(_ req: Request,
                  _ qb: QueryBuilder<Model>,
                  _ order: FieldKey,
                  _ direction: DatabaseQuery.Sort.Direction) -> QueryBuilder<Model> {
        if order == "date" {
            return qb.sortMetadataByDate(direction)
        }
        return qb.sort(order, direction)
    }
    
    func listQuery(_ req: Request, _ qb: QueryBuilder<Model>) -> QueryBuilder<Model> {
        qb.joinMetadata()
    }
    
    
}
