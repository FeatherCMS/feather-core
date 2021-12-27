//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 13..
//

public struct SystemInstallStep: Codable {

    public let key: String
    public let priority: Int
    
    public init(key: String, priority: Int = 0) {
        self.key = key
        self.priority = max(-9998, min(9998, priority))
    }

    static let start = SystemInstallStep(key: "start", priority: 9999)
    static let finish = SystemInstallStep(key: "finish", priority: -9999)
}
