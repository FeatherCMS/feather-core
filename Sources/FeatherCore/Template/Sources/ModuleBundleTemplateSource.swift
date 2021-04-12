//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 09..
//

struct ModuleBundleTemplateSource: NonBlockingFileIOSource {
    
    let module: String
    let rootDirectory: String
    let templatesDirectory: String
    let fileExtension: String
    let fileio: NonBlockingFileIO
    
    init(module: String,
         rootDirectory: String,
         templatesDirectory: String,
         fileExtension: String = "html",
         fileio: NonBlockingFileIO) {
        self.module = module
        self.rootDirectory = rootDirectory
        self.templatesDirectory = templatesDirectory
        self.fileExtension = fileExtension
        self.fileio = fileio
    }

    func file(template: String, escape: Bool = false, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer> {
        let components = template.split(separator: "/")
        let moduleName = components.first!.lowercased()
        let templateName = components.dropFirst().map(String.init).joined(separator: "/")
        guard module == moduleName else {
            return eventLoop.future(error: TemplateError(.noTemplateExists(templateName)))
        }
        let templatesUrl = URL(fileURLWithPath: rootDirectory).appendingPathComponent(templatesDirectory)

        func addfileName(to url: URL) -> URL {
            url.appendingPathComponent(templateName).appendingPathExtension(fileExtension)
        }
        let publicUrl = addfileName(to: templatesUrl.appendingPathComponent("Public"))
        let privateUrl = addfileName(to: templatesUrl.appendingPathComponent("Private"))
        
        return fileio.openFile(path: publicUrl.path, eventLoop: eventLoop)
        .flatMapError { _ in fileio.openFile(path: privateUrl.path, eventLoop: eventLoop) }
        .flatMap { handle, region in
            fileio.read(fileRegion: region, allocator: .init(), eventLoop: eventLoop)
            .flatMapThrowing { buffer in
                try handle.close()
                return buffer
            }
        }
//        .flatMapErrorThrowing { error in throw TemplateError(.noTemplateExists(path)) }
    }
}
