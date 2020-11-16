//
//  Metadata+Filter.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

public extension Metadata {

    /// invokes content filters that are associated to the metadata object
    func filter(_ input: String, req: Request) -> String {
        req.application.viper.invokeAllSyncHooks(name: "content-filter",
                                                 req: req,
                                                 type: [ContentFilter].self)
            .flatMap { $0 }
            .filter { filters.contains($0.key) }
            .reduce(input) { $1.filter($0) }
    }
}
