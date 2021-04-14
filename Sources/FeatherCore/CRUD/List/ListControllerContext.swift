//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

public struct ListControllerContext: Codable {

    public let module: String
    public let model: String
    public let title: String

    public let searchable: Bool
    public let create: Bool
    public let view: Bool
    public let update: Bool
    public let delete: Bool
    
    public let allowedOrders: [String]
    public let defaultOrder: String?
    public let defaultSort: String
}
