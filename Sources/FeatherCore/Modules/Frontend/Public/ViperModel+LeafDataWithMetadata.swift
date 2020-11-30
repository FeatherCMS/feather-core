//
//  ViperModel+LeafDataWithMetadata.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 11. 14..
//

public extension ViperModel where Self: LeafDataRepresentable {

    /// returns the default leaf data object coinaining the metadata leaf data (metadata info must be already joined / present)
    var leafDataWithMetadata: LeafData {
        var data: [String: LeafData] = leafData.dictionary!
        data["metadata"] = try! joined(FrontendMetadata.self).leafData
        return .dictionary(data)
    }
}
