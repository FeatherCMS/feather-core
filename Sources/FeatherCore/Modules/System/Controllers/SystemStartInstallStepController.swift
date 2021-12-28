//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

struct SystemStartInstallStepController: SystemInstallStepController {
    
    func installStep(_ req: Request, info: SystemInstallInfo) async throws -> Response {
        let template = SystemInstallPageTemplate(.init(icon: "🪶",
                                                       title: "Install site",
                                                       message: "First we have to setup the necessary components.",
                                                       link: .init(label: "Start installation →",
                                                                   path: installPath(for: info.currentStep, next: true))))
        return req.templates.renderHtml(template)
    }

    func performInstallStep(_ req: Request, info: SystemInstallInfo) async throws -> Response? {
        let _: [Void] = try await req.invokeAllAsync(.install)
        try await installAssets(req)
        try await continueInstall(req, with: info.nextStep)
        return req.redirect(to: installPath(for: info.nextStep))
    }
    
    func installAssets(_ req: Request) async throws {
        let fm = FileManager.default
        for module in req.application.feather.modules.filter({ $0.bundleUrl != nil }) {
            let moduleUrl = module.bundleUrl!
            let moduleName = type(of: module).featherIdentifier.lowercased()
            
            let assetsUrl = moduleUrl.appendingPathComponent("Assets")
            guard fm.isExistingDirectory(at: assetsUrl.path) else {
                continue
            }
            let assetsDirectories = try fm.contentsOfDirectory(atPath: assetsUrl.path)

            for dir in assetsDirectories {
                let dirUrl = assetsUrl.appendingPathComponent(dir)
                let assetFiles = try fm.contentsOfDirectory(atPath: dirUrl.path)

                for file in assetFiles {
                    let fileUrl = dirUrl.appendingPathComponent(file)
                    /// NOTE: this is not the best solution, but it works for now... both the key & data lines.
                    let key = (moduleName + "/" + dir + "/" + file).safePath()
                    let data = try Data(contentsOf: fileUrl)
                    _ = try await req.fs.upload(key: key, data: data)
                }
            }
        }
    }
}
