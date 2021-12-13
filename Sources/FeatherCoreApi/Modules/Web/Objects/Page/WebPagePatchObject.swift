//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Foundation

extension WebPage {

    public struct Patch: Codable {
        public let title: String?
        public let content: String?
        
        public init(title: String? = nil, content: String? = nil) {
            self.title = title
            self.content = content
        }
    }

}
