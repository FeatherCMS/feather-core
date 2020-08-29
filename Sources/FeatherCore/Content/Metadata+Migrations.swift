//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

public extension Metadata {

    static func migrations() -> [Migration] {
        [
            MetadataMigration_v1_0_0()
        ]
    }
}
