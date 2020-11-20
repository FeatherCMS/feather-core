//
//  FeatherCoreLeafSource.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 11. 20..
//

public struct FeatherCoreLeafSource: NonBlockingFileIOLeafSource {

    /// file extension
    public let fileExtension: String
    /// fileio used to read files
    public let fileio: NonBlockingFileIO
    
    public init(fileExtension: String, fileio: NonBlockingFileIO) {
        self.fileExtension = fileExtension
        self.fileio = fileio
    }

    public func file(template: String, escape: Bool = false, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer> {
        let rootDirectory = Bundle.module.bundleURL
            .appendingPathComponent("Contents")
            .appendingPathComponent("Resources")
            .appendingPathComponent("Templates")
            .path

        let file = rootDirectory + "/" + template  + "." + fileExtension
        return read(path: file, on: eventLoop)
    }
}
