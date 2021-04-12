//
//  Request+QueryDictionary.swift
//  TauFoundation
//
//  Created by Tibor Bodecs on 2020. 11. 17..
//

extension Request {

    /// turns the query into key-value paris separated by the proper url query characters
    var queryDictionary: [String: String] {
        var queryItems: [String: String] = [:]
        for queryItem in url.query?.split(separator: "&") ?? [] {
            let array = queryItem.split(separator: "=")
            guard array.count == 2 else {
                continue
            }
            let key = String(array[0])
            let value = String(array[1])
            queryItems[key] = value
        }
        return queryItems
    }
}
