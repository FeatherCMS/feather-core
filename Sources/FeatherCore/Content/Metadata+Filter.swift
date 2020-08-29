//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

extension Metadata {

    func filter(_ input: String, req: Request) -> String {
        req.application.viper.invokeAllSyncHooks(name: "content-filter",
                                                 req: req,
                                                 type: [ContentFilter].self)
            .flatMap { $0 }
            .filter { self.filters.contains($0.key) }
            .reduce(input) { $1.filter($0) }
    }
}
