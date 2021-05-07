//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//

struct SystemInstallController {
    
    func startStep(req: Request) -> EventLoopFuture<View> {
        req.view.render("System/Install/Start")
    }

    func performStartStep(req: Request, nextStep: String) -> EventLoopFuture<Void> {
        /// upload bundled images using the file storage if there are some files under the Install folder inside the module bundle
        var fileUploadFutures: [EventLoopFuture<Void>] = []
        for module in req.application.feather.modules {
            guard let moduleBundle = module.bundleUrl else {
                continue
            }
            let name = type(of: module).self.moduleKey
            let sourcePath = moduleBundle.appendingPathComponent("Install").path
            let sourceUrl = URL(fileURLWithPath: sourcePath)
            let keys: [URLResourceKey] = [.isDirectoryKey]
            
            let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]
 
            let urls = FileManager.default.enumerator(at: sourceUrl, includingPropertiesForKeys: keys, options: options)!
            for case let fileUrl as URL in urls {
                let resourceValues = try? fileUrl.resourceValues(forKeys: Set(keys))
                if resourceValues?.isDirectory ?? true {
                    continue
                }
                let relativePath = String(fileUrl.path.dropFirst(sourceUrl.path.count + 1))
                let relativeUrl = URL(fileURLWithPath: relativePath, relativeTo: sourceUrl)
                let future = req.fileio.collectFile(at: relativeUrl.path).flatMap { byteBuffer -> EventLoopFuture<Void> in
                    guard let data = byteBuffer.getData(at: 0, length: byteBuffer.readableBytes) else {
                        return req.eventLoop.future()
                    }
                    return req.fs.upload(key: name + "/" + relativeUrl.relativePath, data: data).map { _ in }
                }
                fileUploadFutures.append(future)
            }
        }
        let modelInstallFutures: [EventLoopFuture<Void>] = req.invokeAll(.installModels)
        return req.eventLoop.flatten(modelInstallFutures + fileUploadFutures).map {
            Application.Config.installStep = nextStep
        }
    }

    func finishStep(req: Request) -> EventLoopFuture<View> {
        req.view.render("System/Install/Finish")
    }

    func performFinishStep(req: Request) -> EventLoopFuture<Void> {
        Application.Config.installed = true
        Application.Config.installStep = InstallStep.finish.key
        return req.eventLoop.future()
    }
}
