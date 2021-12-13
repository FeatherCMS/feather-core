//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Foundation

extension WebPage {
    
    public struct Update: Codable {
        public let title: String
        public let content: String
        
        public init(title: String, content: String) {
            self.title = title
            self.content = content
        }
    }

}
