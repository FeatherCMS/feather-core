//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

public extension ByteBuffer {
    var data: Data? { getData(at: 0, length: readableBytes) }
}
