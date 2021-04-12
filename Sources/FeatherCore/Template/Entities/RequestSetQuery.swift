//
//  RequestSetQuery.swift
//  TauFoundation
//
//  Created by Tibor Bodecs on 2020. 10. 23..
//

public struct RequestSetQuery: UnsafeEntity, StringReturn {

    public var unsafeObjects: UnsafeObjects? = nil
    
    public static var callSignature: [CallParameter] { [.init(label: "setQuery", types: [.dictionary])] }
    
    public func evaluate(_ params: CallValues) -> TemplateData {
        guard let req = req else { return .error("Needs unsafe access to Request") }

        var queryItems = req.queryDictionary
        guard let dict = params[0].dictionary else {
            return .error("Invalid dictionary parameter")
        }
        for key in dict.keys {
            guard let value = dict[key]?.string else {
                return .error("Invalid dictionary value")
            }
            queryItems[key] = value
        }
        return .string("\(req.url.path)?\(queryItems.queryString)")
    }
}

