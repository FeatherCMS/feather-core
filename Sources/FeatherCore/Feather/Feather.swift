//
//  Viper.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

/// Feather CMS  a modern Swift-based content management
///
/// Feather is a content management system powered by Vapor 4.
///
/// # Reference:
/// - More details about [Vapor 4](https://docs.vapor.codes/4.0/environment).
/// - More details about [Feather CMS](https://github.com/FeatherCMS/feather).
public struct Feather {

    public static var modulesLocation: String = "Sources/App/Modules/"

    public private(set) var modules: [FeatherModule]
    private unowned var app: Application

    /// initialize with viper modules
    init(app: Application) {
        self.modules = [SystemModule()]
        self.app = app
    }

    /// set viper modules
    public mutating func use(_ modules: [FeatherModule]) {
        self.modules = (self.modules + modules).sorted { $0.priority > $1.priority }
    }

    public func bootModules() throws {
        for module in modules {
            try module.boot(app)
        }
    }
    
    public static func boot(_ app: Application) throws {
        guard app.databases.configuration() != nil else {
            fatalError("Missing database configuration")
        }
        guard app.fileStorages.configuration() != nil else {
            fatalError("Missing file storage configuration")
        }

        setupTemplateEngineEntities()

        app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
        app.routes.defaultMaxBodySize = "10mb"

        app.sessions.use(.fluent)
        app.migrations.add(SessionRecord.migration)
        app.middleware.use(app.sessions.middleware)

        try bootTemplateEngine(app)
        try app.feather.bootModules()
        try app.autoMigrate().wait()

        let _: [Void] = app.invokeAll("routes", args: ["routes": app.routes])
    }
    
    // MARK: - template engine
    
    private static func setupTemplateEngineEntities() {
        TemplateEngine.entities.registerExtendedEntities()
        TemplateEngine.entities.use(RequestParameter(), asFunction: "Request")
        TemplateEngine.entities.use(RequestQuery(), asFunction: "Request")
        TemplateEngine.entities.use(RequestSetQuery(), asFunction: "Request")
        TemplateEngine.entities.use(SortIndicator(), asFunction: "SortIndicator")
        TemplateEngine.entities.use(SortQuery(), asFunction: "SortQuery")
        TemplateEngine.entities.use(TrimLast(), asMethod: "trimLast")
        TemplateEngine.entities.use(ResolveEntity(), asMethod: "resolve")
        TemplateEngine.entities.use(ReplaceYearEntity(), asMethod: "replaceYear")
        TemplateEngine.entities.use(SafePathEntity(), asMethod: "safePath")
        TemplateEngine.entities.use(AbsoluteUrlEntity(), asMethod: "absoluteUrl")
        TemplateEngine.entities.use(InlineSvgEntity(), asFunction: "svg")
        TemplateEngine.entities.use(UserHasPermissionEntity(), asFunction: "UserHasPermission")
//        TemplateEngine.entities.use(TranslationEntity(), asMethod: "t")
    }
    
    private static func bootTemplateEngine(_ app: Application) throws {
        /// override views directory name with templates
        app.directory.viewsDirectory = app.directory.resourcesDirectory + Application.Directories.templates.withTrailingSlash

        /// setup custom template sources based on the modules
        let templateSources = TemplateSources()
        
        /// Resources/Templates/[Default]/
        try templateSources.register(using: FileSource(fileio: app.fileio,
                                                       limits: [.requireExtensions],
                                                       sandboxDirectory: app.directory.resourcesDirectory,
                                                       viewDirectory: app.directory.viewsDirectory + Application.Config.template.withTrailingSlash,
                                                       defaultExtension: "html"))

        for module in app.feather.modules {
            guard let url = module.bundleUrl else { continue }
            let idKey = type(of: module).self.idKey
            let source = ModuleBundleTemplateSource(module: idKey,
                                                    rootDirectory: url.path.withTrailingSlash,
                                                    templatesDirectory: Application.Directories.templates,
                                                    fileio: app.fileio)

            try templateSources.register(source: "\(idKey)-module", using: source)
        }
        
        TemplateEngine.sources = templateSources

        /// renderer configuration
        Renderer.Option.timeout = 1.500 // 1500ms
        if app.isDebug {
            Renderer.Option.caching = .bypass
        }
        app.views.use(.tau)
    }
 
    // MARK: - resource management
    
    public static func resetPublicFiles(resetAssets: Bool = false, _ app: Application) throws {
        let publicUrl = Application.Paths.public
        if resetAssets {
            try FileManager.default.removeFile(at: publicUrl)
        }
        else {
            try FileManager.default.createDirectory(at: publicUrl)
            for item in try FileManager.default.contentsOfDirectory(atPath: publicUrl.path) {
                if item == Application.Directories.assets {
                    continue
                }
                let url = publicUrl.appendingPathComponent(item)
                try FileManager.default.removeFile(at: url)
            }
        }
        try copyPublicFiles(app)
    }

    public static func resetResources(_ app: Application) throws {
        try FileManager.default.removeFile(at: Application.Paths.resources)
        try copyBundleResources(app)
    }
    
    public static func resetTemplates(_ app: Application) throws {
        try FileManager.default.removeFile(at: Application.Paths.templates)
        try copyTemplatesIfNeeded(app)
    }
    
    private static func copyPublicFiles(_ app: Application) throws {
        let publicUrl = Application.Paths.public

        for module in app.feather.modules {
            guard let bundleUrl = module.bundleUrl else {
                continue
            }
            let publicFilesUrl = bundleUrl.appendingPathComponent(Application.Directories.public)
            guard FileManager.default.isExistingDirectory(at: publicFilesUrl.path) else {
                continue
            }

            /// @NOTE: need a better solution for recursively merging files & directories
            let publicSources = try FileManager.default.contentsOfDirectory(atPath: publicFilesUrl.path)
            for publicSource in publicSources {
                let sourceDir = publicFilesUrl.appendingPathComponent(publicSource)
                if FileManager.default.isExistingDirectory(at: sourceDir.path) {
                    let srcs = try FileManager.default.contentsOfDirectory(atPath: sourceDir.path)
                    for src in srcs {
                        let srcFile = sourceDir.appendingPathComponent(src)
                        let targetDir = publicUrl.appendingPathComponent(publicSource)
                        let targetFile = targetDir.appendingPathComponent(src)
                        try FileManager.default.createDirectory(at: targetDir)
                        try FileManager.default.copy(at: srcFile, to: targetFile)
                    }
                }
                else {
                    let targetFile = publicUrl.appendingPathComponent(publicSource)
                    try FileManager.default.copy(at: sourceDir, to: targetFile)
                }
            }
        }
    }

    private static func copyBundleResources(_ app: Application) throws {
        let bundleDir = "Bundle"
        
        guard let bundleUrl = Bundle.module.resourceURL?.appendingPathComponent(bundleDir) else {
            app.logger.warning("Missing FeatherCore bundle resources.")
            return
        }
        let baseUrl = Application.Paths.base
        let bundleResources = try FileManager.default.contentsOfDirectory(atPath: bundleUrl.path)

        /// copy bundled public and resource files if needed
        for resource in bundleResources {
            let source = bundleUrl.appendingPathComponent(resource)
            let destination = baseUrl.appendingPathComponent(resource)
            try FileManager.default.copy(at: source, to: destination)
        }
    }

    public static func copyTemplatesIfNeeded(_ app: Application) throws {
        let templatesUrl = Application.Paths.defaultTemplate
        try FileManager.default.createDirectory(at: templatesUrl)

        for module in app.feather.modules {
            guard let bundleUrl = module.bundleUrl else {
                continue
            }
            let source = bundleUrl.appendingPathComponent(Application.Directories.templates).appendingPathComponent("Public")
            let destination = templatesUrl.appendingPathComponent(type(of: module).self.idKey)
            try FileManager.default.copy(at: source, to: destination)
        }
    }

    private static func minifyExistingCssFiles() throws {
        let cssUrl = Application.Paths.css

        guard FileManager.default.fileExists(atPath: cssUrl.path) else {
            return
        }
        let unminifiedCssFiles = try FileManager.default.contentsOfDirectory(atPath: cssUrl.path)
            .map { cssUrl.appendingPathComponent($0) }
            .filter { $0.pathExtension == "css" && !$0.lastPathComponent.contains(".min.css") }

        for file in unminifiedCssFiles {
            let cssString = try String(contentsOf: file)
            let newFile = file.deletingPathExtension().appendingPathExtension("min").appendingPathExtension("css")
            try cssString.minifiedCss.write(to: newFile, atomically: true, encoding: .utf8)
        }
    }

    // MARK: - experimental dylib

    /// @NOTE: work in progress, do not use this method yet
    ///
    /// Big thanks to [Lopdo](https://github.com/Lopdo) for the plugin loader sample code. 🙏
    ///
    private static func loadDynamicModuleBuilder(named name: String, _ app: Application) -> FeatherModuleBuilder {
        let moduleName = name
        let path = app.directory.resourcesDirectory + "Modules/libDynamic\(moduleName)Module.dylib"

        guard let dylibReference = dlopen(path, RTLD_NOW|RTLD_LOCAL) else {
            if let err = dlerror() {
                fatalError(String(format: "dlopen error - %s", err))
            }
            else {
                fatalError("unknown dlopen error")
            }
        }
        defer {
            dlclose(dylibReference)
        }
        let symbolName = "create\(moduleName)Module"
        
        
        guard let symbol = dlsym(dylibReference, symbolName) else {
            fatalError("dlsym error - create module symbol not found")
        }

        typealias InitFunction = @convention(c) () -> UnsafeMutableRawPointer
        let f: InitFunction = unsafeBitCast(symbol, to: InitFunction.self)
        let pointer = f()
        let builder = Unmanaged<FeatherModuleBuilder>.fromOpaque(pointer).takeRetainedValue()
        return builder
    }
}

