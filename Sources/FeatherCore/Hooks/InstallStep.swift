//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 07..
//

import Foundation

public struct InstallStep: Codable {
    let key: String
    let priority: Int
    
    public init(key: String, priority: Int = 0) {
        self.key = key
        self.priority = priority

        assert(key != InstallStep.start.key, "Key can't be equal with \(InstallStep.start.key) key")
        assert(key != InstallStep.finish.key, "Key can't be equal with \(InstallStep.finish.key) key")
        assert(priority < InstallStep.start.priority, "Priority must be less than \(InstallStep.start.key) priority \(InstallStep.start.priority)")
        assert(priority > InstallStep.finish.priority, "Priority must be greater than \(InstallStep.finish.key) priority \(InstallStep.finish.priority)")
    }
    
    // MARK: - internal

    static let start = InstallStep("start", 9999)
    static let finish = InstallStep("finish", -9999)
    
    fileprivate init(_ key: String, _ priority: Int) {
        self.key = key
        self.priority = priority
    }
}
