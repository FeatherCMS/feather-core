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

    public func paginate(_ req: Request, withDeleted deleted: Bool = false) -> EventLoopFuture<PaginationContainer<T>> {
        return paginate(req, qbAll(req, withDeleted: deleted))
    }
    
    public func paginate(_ req: Request, _ qb: QueryBuilder<T>) -> EventLoopFuture<PaginationContainer<T>> {
       /// pagination
       let listLimit: Int = max(req.query[limitKey] ?? limit, 1)
       let listPage: Int = max(req.query[pageKey] ?? page, 1)
       let start = (listPage - 1) * listLimit
       let end = listPage * listLimit

       let count = qb.count()
       let items = qb.copy().range(start..<end).all()
       
       return count.and(items).map { (total, models) -> PaginationContainer<T> in
           let totalPages = Int(ceil(Float(total) / Float(listLimit)))
           return PaginationContainer(models, info: .init(current: listPage, limit: listLimit, total: totalPages))
       }
    }
    
    public func qbAll(_ req: Request, withDeleted deleted: Bool = false) -> QueryBuilder<T> {
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
        
        /// Deleted
        if deleted {
            qb = qb.withDeleted()
        }
           
        return qb
    }
}

extension ListLoader where T: MetadataRepresentable {
    
    public func qbFromMeta(_ req: Request, withDeleted deleted: Bool = false) -> QueryBuilder<T> {
        return qbAll(req, withDeleted: deleted)
            .filterMetadata(status: .published)
            .sortMetadataByDate()
    }

}
