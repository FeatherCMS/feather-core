//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 13..
//

import Foundation

public struct FeatherInstallStep: Codable {
    let key: String
    let priority: Int
    
    public init(key: String, priority: Int = 0) {
        self.key = key
        self.priority = priority

        assert(key != FeatherInstallStep.start.key, "Key can't be equal with \(FeatherInstallStep.start.key) key")
        assert(key != FeatherInstallStep.finish.key, "Key can't be equal with \(FeatherInstallStep.finish.key) key")
        assert(priority < FeatherInstallStep.start.priority, "Priority must be less than \(FeatherInstallStep.start.key) priority \(FeatherInstallStep.start.priority)")
        assert(priority > FeatherInstallStep.finish.priority, "Priority must be greater than \(FeatherInstallStep.finish.key) priority \(FeatherInstallStep.finish.priority)")
    }
    
    // MARK: - internal

    static let start = FeatherInstallStep("start", 9999)
    static let finish = FeatherInstallStep("finish", -9999)
    
    fileprivate init(_ key: String, _ priority: Int) {
        self.key = key
        self.priority = priority
    }
}
