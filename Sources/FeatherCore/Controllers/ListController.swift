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
    
    static func listPermission() -> FeatherPermission
    static func listPermission() -> String
    static func hasListPermission(_ req: Request) -> Bool

    func listSearch(_ term: String) -> [ModelValueFilter<Model>]
    func listTemplate(_ req: Request, _ list: ListContainer<Model>) -> TemplateRepresentable
    func listAccess(_ req: Request) async -> Bool
    func listView(_ req: Request) async throws -> Response
    func listApi(_ req: Request) async throws -> ListContainer<Model>
}

public extension ListController {

    var listConfig: ListConfiguration { .init() }

    func listSearch(_ term: String) -> [ModelValueFilter<Model>] {
        []
    }
    
    static func listPermission() -> FeatherPermission {
        Model.permission(.list)
    }
    
    static func listPermission() -> String {
        listPermission().rawValue
    }
    
    static func hasListPermission(_ req: Request) -> Bool {
        req.checkPermission(listPermission())
    }
    
    func listAccess(_ req: Request) async -> Bool {
        await req.checkAccess(for: Self.listPermission())
    }

    func listApi(_ req: Request) async throws -> ListContainer<Model> {
        let hasAccess = await listAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        return try await list(req)
    }

    func listView(_ req: Request) async throws -> Response {
        let hasAccess = await listAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let list = try await list(req)
        return req.html.render(listTemplate(req, list))
    }
}

private extension ListController {

    func list(_ req: Request) async throws -> ListContainer<Model> {
        let config = listConfig
        let listLimit: Int = max(req.query[config.limitKey] ?? config.defaultLimit, 1)
        let listPage: Int = max(req.query[config.pageKey] ?? config.defaultPage, 1)
        
        var qb = Model.query(on: req.db)
        
//        if let beforeQuery = beforeQuery {
//            qb = beforeQuery(req, qb)
//        }

        let allowedOrders = config.allowedOrders
        var listOrder = allowedOrders.first
        if !allowedOrders.isEmpty, let rawOrder: String = req.query[config.orderKey], allowedOrders.contains(.string(rawOrder)) {
            listOrder = .string(rawOrder)
        }

        var listSort: FieldSort = config.defaultSort
        if let rawSort: String = req.query[config.sortKey], let sortValue = FieldSort(rawValue: rawSort) {
            listSort = sortValue
        }
        
        if let order = listOrder {
            // NOTE: listSort(qb, order, direction)
            qb = qb.sort(order, listSort.direction)
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
