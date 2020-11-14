//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 14..
//

import Vapor
import Leaf
import ViperKit

public extension ViperModel where Self: LeafDataRepresentable {
    
    func joinedMetadata() -> LeafData {
        var data: [String: LeafData] = leafData.dictionary!
        data["metadata"] = try! joined(Metadata.self).leafData
        return .dictionary(data)
    }
}
