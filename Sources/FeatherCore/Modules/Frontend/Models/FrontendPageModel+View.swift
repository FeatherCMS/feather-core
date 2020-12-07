//
//  FrontendPageModel+View.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

extension FrontendPageModel: LeafDataRepresentable {

    var leafData: LeafData {
        .dictionary([
            "id": id,
            "title": title,
            "content": content,
        ])
    }    
}
