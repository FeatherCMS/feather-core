//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Foundation

public enum WebMetadata {}


extension WebMetadata {

    public enum Status: String, Codable {
        case draft
        case published
        case archived
    }
}
