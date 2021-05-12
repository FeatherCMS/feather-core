//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

public struct ListLoader<T: FeatherModel>  {
    
    let sortKey: String
    let orderKey: String
    let searchKey: String
    let limitKey: String
    let limit: Int
    let pageKey: String
    let page: Int
    let beforeQuery: ((Request, QueryBuilder<T>) -> QueryBuilder<T>)?
    
    public init(sortKey: String = "sort",
                orderKey: String = "order",
                searchKey: String = "search",
                limitKey: String = "limit",
                limit: Int = 10,
                pageKey: String = "page",
                page: Int = 1,
                beforeQuery: ((Request, QueryBuilder<T>) -> QueryBuilder<T>)? = nil)
    {
        self.sortKey = sortKey
        self.orderKey = orderKey
        self.searchKey = searchKey
        self.limitKey = limitKey
        self.limit = limit
        self.pageKey = pageKey
        self.page = page
        self.beforeQuery = beforeQuery
    }
    
    /// query all the objects & paginate them
    public func paginateAll(_ req: Request) -> EventLoopFuture<PaginationContainer<T>> {
        paginate(req, queryAll(req))
    }
    
    /// paginate a query builder based on the request params
    public func paginate(_ req: Request, _ qb: QueryBuilder<T>) -> EventLoopFuture<PaginationContainer<T>> {
        let listLimit: Int = max(req.query[limitKey] ?? limit, 1)
        let listPage: Int = max(req.query[pageKey] ?? page, 1)
        let start = (listPage - 1) * listLimit
        let end = listPage * listLimit
        
        let count = qb.count()
        // NOTE: fix for mongo driver
        let items: EventLoopFuture<[T]>
        if start > 0 {
            items = qb.copy().range(start..<end).all()
        }
        else {
            items = qb.copy().limit(end).all()
        }
        
        return count.and(items).map { (total, models) -> PaginationContainer<T> in
            let totalPages = Int(ceil(Float(total) / Float(listLimit)))
            return PaginationContainer(models, info: .init(current: listPage, limit: listLimit, total: totalPages))
        }
    }
    
    public func queryAll(_ req: Request) -> QueryBuilder<T> {
        var qb = T.query(on: req.db)
        if let beforeQuery = beforeQuery {
            qb = beforeQuery(req, qb)
        }
        
        /// sort & order
        let allowedOrders = T.self.allowedOrders()
        var listOrder = allowedOrders.first
        if !allowedOrders.isEmpty, let rawOrder: String = req.query[orderKey], allowedOrders.contains(.string(rawOrder)) {
            listOrder = .string(rawOrder)
        }
        
        var listSort: FieldSort = T.self.defaultSort()
        if let rawSort: String = req.query[sortKey], let sortValue = FieldSort(rawValue: rawSort) {
            listSort = sortValue
        }
        
        if let order = listOrder {
            qb = T.sort(queryBuilder: qb, order: order, direction: listSort.direction)
        }
        
        // search by terms
        if let term: String = req.query[searchKey], !term.isEmpty {
            qb = qb.group(.or) { qb in
                for v in T.self.search(term) {
                    qb.filter(v)
                }
            }
        }
        
        let deleted: Bool = req.query["deleted"] ?? false
        if deleted {
            qb = qb.withDeleted()
        }
        
        return qb
    }
}

public extension ListLoader where T: MetadataRepresentable {
    
    /// returns all the publicly available objects
    func queryAllPublic(_ req: Request) -> QueryBuilder<T> {
        queryAll(req).filterPublic()
    }
    
    func paginateAllPublic(_ req: Request) -> EventLoopFuture<PaginationContainer<T>> {
        paginate(req, queryAllPublic(req))
    }
}
