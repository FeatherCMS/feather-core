//
//  SortQuery.swift
//  TauFoundation
//
//  Created by Tibor Bodecs on 2020. 10. 23..
//

fileprivate extension String {
    
    var toggleSort: String {
        if self == "asc" {
            return "desc"
        }
        return "asc"
    }
}

public struct SortQuery: UnsafeEntity, StringReturn {

    public var unsafeObjects: UnsafeObjects? = nil
    
    public static var callSignature: [CallParameter] {
        [
            /// field key
            .init(label: "for", types: [.string]),
            .init(label: "default", types: .bool, optional: true, defaultValue: .bool(false)),
            .init(label: "sort", types: .string, optional: true, defaultValue: .string("asc")),
        ]
    }
    
    public func evaluate(_ params: CallValues) -> TemplateData {
        guard let req = req else { return .error("Needs unsafe access to Request") }
        /// we split the query items and store them in a dictionary
        var queryItems = req.queryDictionary
        /// we check the old order and sort values
        let oldOrder = queryItems["order"]
        let oldSort = queryItems["sort"]
        /// we update the order based on the input
        let fieldKey = params[0].string!
        queryItems["order"] = fieldKey
        
        let isDefaultOrder = params[1].bool!
        /// if there was no old order and this is the default order that means we have to use the default sort
        if oldOrder == nil && isDefaultOrder {
            queryItems["sort"] = params[2].string!.toggleSort
        }
        /// if the old order was equal with the field key we just flip the sort
        else if oldOrder == fieldKey {
            if let sort = oldSort {
                queryItems["sort"] = sort.toggleSort
            }
            else {
                queryItems["sort"] = params[2].string!.toggleSort
            }
        }
        /// otherwise this is a completely new order we can remove the sort key completely
        else {
            queryItems.removeValue(forKey: "sort")
        }
        return .string("\(req.url.path)?\(queryItems.queryString)")
    }
}
