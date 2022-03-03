//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 28..
//

import Foundation

public extension String {

    static func generateToken(_ length: Int = 64) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
}
