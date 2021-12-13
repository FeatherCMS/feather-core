//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

import Vapor

public extension File {

    var byteBuffer: ByteBuffer { data }

    var dataValue: Data? { byteBuffer.getData(at: 0, length: byteBuffer.readableBytes) }
}
