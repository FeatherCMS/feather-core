//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Foundation

public protocol MetadataRepresentable: FeatherModel {

    var metadata: FeatherMetadata { get }
}
