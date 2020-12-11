//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

import Foundation

public struct FrontendMetadataObject: Codable {

    public enum Status: String, Codable {
        case draft
        case published
        case archived
    }

    public var id: UUID?

    public var module: String
    public var model: String
    public var reference: UUID
    
    public var slug: String
    public var title: String?
    public var excerpt: String?
    public var imageKey: String?
    public var date: Date
    public var status: Status
    public var feedItem: Bool
    public var canonicalUrl: String?

    public var filters: [String]
    public var css: String?
    public var js: String?
}
