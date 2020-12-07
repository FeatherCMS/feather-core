//
//  FrontendPageModel+Content.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 07. 22..
//

extension FrontendPageModel: FrontendMetadataChangeDelegate {
    
    var slug: String { title.slugify() }
    
    func willUpdate(_ metadata: FrontendMetadata) {
        if !metadata.$id.exists || (metadata.$id.exists && !metadata.slug.isEmpty) {
            metadata.slug = slug
        }
        metadata.title = title
    }
}
