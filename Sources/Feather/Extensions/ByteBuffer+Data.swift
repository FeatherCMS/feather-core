//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

import Vapor

public extension ByteBuffer {

    /// converts a byte buffer to an optional data value using the readableBytes
    var data: Data? { getData(at: 0, length: readableBytes) }
}
