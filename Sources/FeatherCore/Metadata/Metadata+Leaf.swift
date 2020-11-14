//
//  Metadata+Leaf.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

extension Metadata: LeafDataRepresentable {

    public var leafData: LeafData {
        .dictionary([
            "id": .string(id?.uuidString),
            "module": .string(module),
            "model": .string(model),
            "reference": .string(reference.uuidString),
            "slug": .string(slug),
            "date": .double(date.timeIntervalSinceReferenceDate),
            "status": .string(status.rawValue),
            "filters": .array(filters),
            "feedItem": .bool(feedItem),
            "title": .string(title),
            "excerpt": .string(excerpt),
            "imageKey": .string(imageKey),
            "canonicalUrl": .string(canonicalUrl),
        ])
    }
}
