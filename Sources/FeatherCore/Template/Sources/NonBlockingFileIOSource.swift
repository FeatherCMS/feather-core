//
//  NonBlockingFileIOSource.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 11. 18..
//

// NOTE: this should be moved to Tau
public protocol NonBlockingFileIOSource: Source {

    var fileio: NonBlockingFileIO { get }
    
    func read(path: String, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer>
}

public extension NonBlockingFileIOSource {

    func read(path: String, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer> {
        fileio.openFile(path: path, eventLoop: eventLoop)
        .flatMapErrorThrowing { _ in throw TemplateError(.noTemplateExists(path)) }
        .flatMap { handle, region in
            fileio.read(fileRegion: region, allocator: .init(), eventLoop: eventLoop)
            .flatMapThrowing { buffer in
                try handle.close()
                return buffer
            }
        }
    }
}
