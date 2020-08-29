//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

extension Metadata {

    var metaContext: MetaContext {
        .init(title: self.title,
              excerpt: self.excerpt,
              imageKey: self.imageKey,
              canonicalUrl: self.canonicalUrl,
              indexed: self.status == .published)
    }
}
