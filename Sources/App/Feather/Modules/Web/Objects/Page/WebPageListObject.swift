//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Foundation

extension WebPage {

    public struct List: Codable {
        public let id: UUID
        public let title: String
        
        public init(id: UUID, title: String) {
            self.id = id
            self.title = title
        }
    }

}
