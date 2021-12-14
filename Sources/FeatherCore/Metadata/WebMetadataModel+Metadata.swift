//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Foundation

extension WebMetadataModel {

    func use(_ metadata: FeatherMetadata) {
        if let value = metadata.id { id = value }
        if let value = metadata.module { module = value }
        if let value = metadata.model { model = value }
        if let value = metadata.reference { reference = value }
        if let value = metadata.slug { slug = value }
        if let value = metadata.status { status = value }
        if let value = metadata.title { title = value }
        if let value = metadata.excerpt { excerpt = value }
        if let value = metadata.imageKey { imageKey = value }
        if let value = metadata.date { date = value }
        if let value = metadata.feedItem { feedItem = value }
        if let value = metadata.canonicalUrl { canonicalUrl = value }
        if let value = metadata.filters { filters = value }
        if let value = metadata.css { css = value }
        if let value = metadata.js { js = value }
    }

    var metadata: FeatherMetadata {
        .init(id: id,
              module: module,
              model: model,
              reference: reference,
              slug: slug,
              status: status,
              title: title,
              excerpt: excerpt,
              imageKey: imageKey,
              date: date,
              feedItem: feedItem,
              canonicalUrl: canonicalUrl,
              filters: filters,
              css: css,
              js: js)
    }
}
