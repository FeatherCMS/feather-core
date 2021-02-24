//
//  Feather.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 09..
//

/// Feather CMS  a modern Swift-based content management
///
/// Feather is a content management system powered by Vapor 4.
///
/// # Reference:
/// - More details about [Vapor 4](https://docs.vapor.codes/4.0/environment).
/// - More details about [Feather CMS](https://github.com/FeatherCMS/feather).
public struct Feather {
    
    public static var metadataDelegate: MetadataDelegate?
    
    // MARK: - application management

    /// application reference
    public let app: Application

    ///
    /// Designated initializer
    ///
    public init(env: Environment) throws {
        app = Application(env)
        
        setMaxUploadSize()
    }

    ///
    /// Start the application and bind the listening port
    ///
    /// - Throws: Simply rethrows the error object from the Vapor `try app.run()` call.
    ///
    public func start() throws {
        try app.run()
    }

    ///
    /// Stop the application and unbind the listening port
    ///
    public func stop() {
        app.shutdown()
    }
    
    // MARK: - resource management
    
    /// Recreates the `Public` folder based on the bundled public files
    ///
    /// - parameters:
    ///     - resetAssets: If true, the entire Public folder will be removed, otherwise assets will be kept, default value is *false*
    ///
    /// **NOTE:** The method will keep the assets folder by default, you can reset those as well by setting the resetAssets property to true.
    ///
    /// **WARNING:**  Call this method after modules are configured, otherwise module bundled CSS files won't be processed.
    ///
    public func resetPublicFiles(resetAssets: Bool = false) throws {
        let publicUrl = Application.Paths.public
        if resetAssets {
            try FileManager.default.removeFile(at: publicUrl)
        }
        else {
            for item in try FileManager.default.contentsOfDirectory(atPath: publicUrl.path) {
                if item == Application.Directories.assets {
                    continue
                }
                let url = publicUrl.appendingPathComponent(item)
                try FileManager.default.removeFile(at: url)
            }
        }
        try copyPublicFiles()
        try processCssFiles()
    }

    /// Recreates the `Resources` folder based on the bundled resources
    public func resetResources() throws {
        try FileManager.default.removeFile(at: Application.Paths.resources)
        try copyBundleResources()
    }
    
    /// Recreates the `Templates` folder based on the bundled templates
    public func resetTemplates() throws {
        try FileManager.default.removeFile(at: Application.Paths.templates)
        try copyTemplatesIfNeeded()
    }
    
    /// copies the bundled resources from the modules & feather core to the Public & Resources folders
    private func copyPublicFiles() throws {
        let publicUrl = Application.Paths.public
        
        for module in app.viper.modules {
            guard
                /// check if public files directory exists for the module
                let publicFilesUrl = module.bundleUrl?.appendingPathComponent(Application.Directories.public),
                FileManager.default.isExistingDirectory(at: publicFilesUrl.path)
            else {
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

    /// copy FeatherCore resource files from the Bundle folder to the app base folder
    private func copyBundleResources() throws {
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

    /// copy bundled module templates to the resources folder
    public func copyTemplatesIfNeeded() throws {
        let templatesUrl = Application.Paths.templates
        try FileManager.default.createDirectory(at: templatesUrl)

        for module in app.viper.modules {
            guard let bundleUrl = module.bundleUrl else {
                continue
            }
            let source = bundleUrl.appendingPathComponent(Application.Directories.templates)
            let destination = templatesUrl.appendingPathComponent(module.name.lowercased().capitalized)
            try FileManager.default.copy(at: source, to: destination)
        }
    }

    // MARK: - css processing
    
    fileprivate struct Css {
        enum `Type` {
            case inline
            case link
        }
        let name: String
        let priority: Int
        let fileName: String?
        let snippet: String?
        
        /// use name if fileName was not provided
        var file: String {
            fileName ?? name
        }
        
        /// shortcut for css file url
        var fileUrl: URL {
            Application.Paths.css.appendingPathComponent(file).appendingPathExtension("css")
        }
    }
    
    /// invokes cssHooks and returns the merged dictionary as a Css array sorted by priority
    private func invokeCssHooks() -> [Css] {
        let cssHookResult: [[[String: Any]]] = app.invokeAll("css")
        let cssArray = cssHookResult.flatMap { $0 }

        return cssArray.compactMap { item -> Css? in
            /// skip css if name is missing...
            guard let name = item["name"] as? String else {
                return nil
            }
            /// skip css if name is reserved by the system (style)
            guard name != "style" else {
                return nil
            }
            let priority = item["priority"] as? Int ?? 0
            let fileName = item["file"] as? String
            let snippet = item["snippet"] as? String

            return Css(name: name, priority: priority, fileName: fileName, snippet: snippet)
        }
        .sorted { $0.priority > $1.priority }
    }

    /// process and minify all the css files using the public css folder
    private func minifyExistingCssFiles() throws {
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

    /// create a complete style.css file, based on the css hook then save it minified
    private func processCssFiles() throws {
        let cssUrl = Application.Paths.css
        let cssFiles = invokeCssHooks()
        
        var fullCss: [String] = []
        for css in cssFiles {
            /// if the css is a snippet we also save it as a file...
            if let snippet = css.snippet {
                try snippet.write(to: css.fileUrl, atomically: true, encoding: .utf8)
                fullCss.append(snippet)
            }
            if let cssString = try? String(contentsOf: css.fileUrl) {
                fullCss.append(cssString)
            }
            else {
                app.logger.notice("Missing CSS file: `\(css.file)`")
            }
        }

        let fullCssString = fullCss.joined()
        let fullCssName = cssUrl.appendingPathComponent("style").appendingPathExtension("min").appendingPathExtension("css")
        try fullCssString.minifiedCss.write(to: fullCssName, atomically: true, encoding: .utf8)
    }

    // MARK: - experimental dylib

    /// @NOTE: work in progress, do not use this method yet
    ///
    /// Big thanks to [Lopdo](https://github.com/Lopdo) for the plugin loader sample code. 🙏
    ///
    private func loadDynamicModuleBuilder(named name: String) -> ViperBuilder {
        let moduleName = name.lowercased().capitalized
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
        let builder = Unmanaged<ViperBuilder>.fromOpaque(pointer).takeRetainedValue()
        return builder
    }
    
    // MARK: - configuration
    
    ///
    /// Use a given database driver for a provided database identifier
    ///
    /// - parameters:
    ///     - database: An instance of Type [DatabaseConfigurationFactory](https://docs.vapor.codes/4.0/fluent/overview)
    ///     - databaseId: An Instance of Type [DatabaseID](https://docs.vapor.codes/4.0/fluent/overview)
    public func use(database: DatabaseConfigurationFactory, databaseId: DatabaseID) {
        app.databases.use(database, as: databaseId)
    }

    ///
    /// Use a given file storage for a provided identifier
    ///
    /// - parameters:
    ///     - fileStorage: An Instance of Type [FileStorageConfigurationFactory](https://github.com/BinaryBirds/liquid-kit)
    ///     - fileStorageId: File storage Type [FileStorageID](https://github.com/BinaryBirds/liquid-kit)
    public func use(fileStorage: FileStorageConfigurationFactory, fileStorageId: FileStorageID) {
        app.fileStorages.use(fileStorage, as: fileStorageId)
    }

    /// Use the public file middleware
    public func usePublicFileMiddleware() {
        app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    }

    /// Set the default max body size for the routes
    ///     - maxUploadSize: (Optional)  An Instance of Type **ByteCount** - Required format: **XXmb** - Default: 10mb
    public func setMaxUploadSize(_ maxUploadSize: ByteCount = "10mb") {
        /// set the default max body size for the routes
        app.routes.defaultMaxBodySize = maxUploadSize
    }

    ///
    /// This function will configure the system using the given modules
    ///
    /// - parameters:
    ///     - builders: An Array containing intances of [ViperBuilder](https://github.com/BinaryBirds/viper-kit) objects
    ///
    public func configure(_ builders: [ViperBuilder] = []) throws {
        /// use Vapor session
        app.sessions.use(.fluent)
        app.migrations.add(SessionRecord.migration)
        app.middleware.use(app.sessions.middleware)
        
        /// add  custom middlewares
        app.middleware.use(SlashMiddleware())
        app.middleware.use(RequestCacheMiddleware())
        app.middleware.use(LeafFoundationMiddleware())
        
        /// override views directory name with templates
        app.directory.viewsDirectory = app.directory.resourcesDirectory + Application.Directories.templates.withTrailingSlash

        /// configure Leaf sources using the modules
        let defaultSource = NIOLeafFiles(fileio: app.fileio,
                                         limits: [.requireExtensions],
                                         sandboxDirectory: app.directory.resourcesDirectory,
                                         viewDirectory: app.directory.viewsDirectory,
                                         defaultExtension: "html")
        
        let multipleSources = LeafSources()
        try multipleSources.register(using: defaultSource)
        let modules = builders.map { $0.build() }
        for module in modules {
            guard let url = module.bundleUrl else { continue }

            let moduleSource = ViperBundledLeafSource(module: module.name,
                                                      rootDirectory: url.path.withTrailingSlash,
                                                      templatesDirectory: Application.Directories.templates,
                                                      fileExtension: "html",
                                                      fileio: app.fileio)
            
            try multipleSources.register(source: "\(module.name)-module-bundle", using: moduleSource)
        }
        
        LeafEngine.sources = multipleSources
        
        /// register custom leaf entities
        LeafEngine.useLeafFoundation()
        LeafEngine.entities.use(ResolveLeafEntity(), asMethod: "resolve")
        LeafEngine.entities.use(ReplaceYearLeafEntity(), asMethod: "replaceYear")
        LeafEngine.entities.use(SafePathLeafEntity(), asMethod: "safePath")
        LeafEngine.entities.use(AbsoluteUrlLeafEntity(), asMethod: "absoluteUrl")

        LeafEngine.entities.use(IntMinLeafEntity(), asFunction: "min")
        LeafEngine.entities.use(IntMaxLeafEntity(), asFunction: "max")
        LeafEngine.entities.use(InlineSvgLeafEntity(iconset: "feather-icons"), asFunction: "svg")
        LeafEngine.entities.use(InvokeHookLeafEntity(), asFunction: "InvokeHook")
        LeafEngine.entities.use(InvokeAllHooksLeafEntity(), asFunction: "InvokeAllHooks")
        LeafEngine.entities.use(UserHasPermissionLeafEntity(), asFunction: "UserHasPermission")
//        LeafEngine.entities.use(TranslationLeafEntity(), asMethod: "t")
        
        /// configure LeafRenderer
        LeafRenderer.Option.timeout = 1.500 // 1500ms
        if app.isDebug {
            LeafRenderer.Option.caching = .bypass
        }
        /// usse leaf
        app.views.use(.leaf)

        /// use the modules
        try app.viper.use(modules)

        /// register other leaf related core middlewares
        
        /// core bundle & public files are required
        try copyBundleResources()
        try copyPublicFiles()
        try processCssFiles()

        let files = invokeCssHooks().map { css -> LeafData in
            .string(css.file)
        }

        var generators: [String: LeafDataGenerator] {
            [
                "css": .immediate(LeafData.array(files)),
            ]
        }

        app.middleware.use(LeafScopeMiddleware(scope: "app", generators: generators))
        app.middleware.use(FeatherCoreLeafExtensionMiddleware())
        app.middleware.use(ViperLeafScopesMiddleware())

        /// run auto-migration process before start
        try app.autoMigrate().wait()
    }
}




