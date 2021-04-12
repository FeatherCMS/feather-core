//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 12..
//

/// a viper model extension that can return a metadata object
public protocol MetadataRepresentable: FeatherModel {

    var metadata: Metadata { get }
}
