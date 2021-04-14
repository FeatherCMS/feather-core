//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

public extension File {

    var byteBuffer: ByteBuffer { data }

    var dataValue: Data? { byteBuffer.getData(at: 0, length: byteBuffer.readableBytes) }
}
