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
/// - More details about [Feather CMS](https://github.com/BinaryBirds/feather).
/// - Available public [Feather CMS modules ](https://github.com/feather-modules).
public struct Feather {

    private let coreModules = [
        UserBuilder(),
        SystemBuilder(),
        AdminBuilder(),
        ApiBuilder(),
        FrontendBuilder(),
    ]

    /// application reference
    public let app: Application

    ///
    /// Designated initializer
    ///
    public init(env: Environment) throws {
        app = Application(env)
    }

    ///
    /// Start the application and bind the listening port
    ///
    /// - Throws: `Error` due to `FileManager` error when copying default "Public", "Resources"
    ///
    public func start() throws {
        try copyBundledResources()
        /// run the application
        try app.run()
    }
    
    /// Removes the Public & Resources folders
    public func reset(resourcesOnly: Bool = false) throws {
        var items = ["Resources"]
        if !resourcesOnly {
            items.append("Public")
        }
        let base = URL(fileURLWithPath: Application.Paths.base)
        for item in items {
            let dest = base.appendingPathComponent(item)
            if FileManager.default.fileExists(atPath: dest.path) {
                try FileManager.default.removeItem(at: dest)
            }
        }
    }
    
    /// copies the bundled resources from the modules & feather core to the Public & Resources folders
    private func copyBundledResources() throws {
        guard let resources = Bundle.module.resourceURL else {
            return
        }
        let core = resources.appendingPathComponent("Bundles").appendingPathComponent("Core")
        let base = URL(fileURLWithPath: Application.Paths.base)

        /// copy bundled public and resource files if needed
        for item in ["Public", "Resources"] {
            let source = core.appendingPathComponent(item)
            let dest = base.appendingPathComponent(item)
            if !FileManager.default.fileExists(atPath: dest.path) {
                try FileManager.default.copyItem(at: source, to: dest)
            }
        }
        
        /// process and minify css files using the public/css folder
        let cssDir = base.appendingPathComponent("Public").appendingPathComponent("css")
        let contents = try FileManager.default.contentsOfDirectory(atPath: cssDir.path)
        let cssFiles = contents.map { cssDir.appendingPathComponent($0) }
            .filter { $0.pathExtension == "css" && !$0.lastPathComponent.contains(".min.css") }
        
        for file in cssFiles {
            let cssString = try String(contentsOf: file)
            let newFile = file.deletingPathExtension().appendingPathExtension("min").appendingPathExtension("css")
            try cssString.minifiedCss.write(to: newFile, atomically: true, encoding: .utf8)
        }
        
        /// copy bundled templates
        let tpl = URL(fileURLWithPath: Application.Paths.resources).appendingPathComponent("Templates")
        
        if !FileManager.default.fileExists(atPath: tpl.path) {
            try FileManager.default.createDirectory(at: tpl, withIntermediateDirectories: true, attributes: [.posixPermissions: 0o744])
        }

        for module in app.viper.modules {
            guard let bundle = module.bundleUrl else {
                continue
            }
            let source = bundle.appendingPathComponent("Templates")
            let dest = tpl.appendingPathComponent(module.name.lowercased().capitalized)
            if !FileManager.default.fileExists(atPath: dest.path) {
                try FileManager.default.copyItem(at: source, to: dest)
            }
        }
    }

    ///
    /// Stop the application and unbind the listening port
    ///
    public func stop() {
        app.shutdown()
    }

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

    ///
    /// This function will configure the instance
    ///
    /// - Throws: `Error` due to `modules` registration
    ///
    /// - parameters:
    ///     - database: An instance of Type [DatabaseConfigurationFactory](https://docs.vapor.codes/4.0/fluent/overview)
    ///     - databaseId: An Instance of Type [DatabaseID](https://docs.vapor.codes/4.0/fluent/overview)
    ///     - fileStorage: An Instance of Type [FileStorageConfigurationFactory](https://github.com/BinaryBirds/liquid-kit)
    ///     - fileStorageId: File storage Type [FileStorageID](https://github.com/BinaryBirds/liquid-kit)
    ///     - maxUploadSize: (Optional)  An Instance of Type **ByteCount** - Required format: **XXmb** - Default: 10mb
    ///     - modules: An Array containing intances of type [ViperBuilder](https://github.com/BinaryBirds/viper-kit)
    ///     - usePublicFileMiddleware: (Optional) A **Bool** to deactivate the MiddleWare, if you implemented your own -  Default **true**
    ///
    public func configure(database: DatabaseConfigurationFactory,
                      databaseId: DatabaseID,
                      fileStorage: FileStorageConfigurationFactory,
                      fileStorageId: FileStorageID,
                      maxUploadSize: ByteCount = "10mb",
                      modules userModules: [ViperBuilder] = [],
                      usePublicFileMiddleware: Bool = true) throws {
 
        /// override views directory name with templates
        app.directory.viewsDirectory = app.directory.resourcesDirectory + "Templates/"
        
        if usePublicFileMiddleware {
            app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
        }
        
        app.databases.use(database, as: databaseId)
        app.fileStorages.use(fileStorage, as: fileStorageId)

        app.routes.defaultMaxBodySize = maxUploadSize
        
        app.sessions.use(.fluent)
        app.migrations.add(SessionRecord.migration)
        app.middleware.use(SlashMiddleware())
        app.middleware.use(RequestCacheMiddleware())
        app.middleware.use(app.sessions.middleware)
        app.middleware.use(LeafFoundationMiddleware())
        
        let defaultSource = NIOLeafFiles(fileio: app.fileio,
                                         limits: [.requireExtensions],
                                         sandboxDirectory: app.directory.resourcesDirectory,
                                         viewDirectory: app.directory.viewsDirectory,
                                         defaultExtension: "html")
        
        let multipleSources = LeafSources()
        try multipleSources.register(using: defaultSource)

        let modules = (coreModules + userModules).map { $0.build() }
        for module in modules {
            guard let url = module.bundleUrl else { continue }

            let moduleSource = ViperBundledLeafSource(module: module.name,
                                                      rootDirectory: url.path.withTrailingSlash,
                                                      templatesDirectory: "Templates",
                                                      fileExtension: "html",
                                                      fileio: app.fileio)
            
            try multipleSources.register(source: "\(module.name)-module-bundle", using: moduleSource)
        }
        
        LeafEngine.sources = multipleSources
        LeafEngine.useLeafFoundation()
        LeafEngine.entities.use(ResolveLeafEntity(), asMethod: "resolve")
        LeafEngine.entities.use(SafePathEntity(), asMethod: "safePath")
        LeafEngine.entities.use(AbsoluteUrlEntity(), asMethod: "absoluteUrl")
//        LeafEngine.entities.use(TranslationLeafEntity(), asMethod: "t")

        LeafEngine.entities.use(MinEntity(), asFunction: "min")
        LeafEngine.entities.use(MaxEntity(), asFunction: "max")
        LeafEngine.entities.use(InlineSvg(iconset: "feather-icons"), asFunction: "svg")

        
        LeafEngine.entities.use(InvokeHookLeafEntity(), asFunction: "InvokeHook")
        LeafEngine.entities.use(InvokeAllHooksLeafEntity(), asFunction: "InvokeAllHooks")
        
        
        LeafEngine.entities.use(UserHasPermissionLeafEntity(), asFunction: "UserHasPermission")
        LeafRenderer.Option.timeout = 1.000 // 1000ms
        
        if app.isDebug {
            LeafRenderer.Option.caching = .bypass
        }
        app.views.use(.leaf)

        try app.viper.use(modules)

        app.middleware.use(FeatherCoreLeafExtensionMiddleware())
        app.middleware.use(ViperLeafScopesMiddleware())

        try app.autoMigrate().wait()
    }
}
