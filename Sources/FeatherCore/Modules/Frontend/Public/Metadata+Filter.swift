//
//  Metadata+Filter.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

public extension FrontendMetadata {

    /// invokes content filters that are associated to the metadata object    
    func filter(_ input: String, req: Request) -> String {
        let result: [[ContentFilter]] = req.invokeAll("content-filters")
        return result.flatMap { $0 }.filter { filters.contains($0.key) }.reduce(input) { $1.filter($0) }
    }
}
