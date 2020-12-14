//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 09..
//

public struct Feather {
    
    private let coreModules = [
        UserBuilder(),
        SystemBuilder(),
        AdminBuilder(),
        ApiBuilder(),
        FrontendBuilder(),
    ]

    public let app: Application

    public init(env: inout Environment) throws {
        app = Application(env)
    }

    public func start() throws {
        
        /// copy bundled files & resources if needed
        if let resources = Bundle.module.resourceURL {
            let core = resources.appendingPathComponent("Bundles").appendingPathComponent("Core")
            let base = URL(fileURLWithPath: Application.Paths.base)

            for item in ["Public", "Resources"] {
                let source = core.appendingPathComponent(item)
                let dest = base.appendingPathComponent(item)
                if !FileManager.default.fileExists(atPath: dest.path) {
                    try FileManager.default.copyItem(at: source, to: dest)
                }
            }
        }
        /// run the application
        try app.run()
    }

    public func stop() {
        app.shutdown()
    }

    public func configure(database: DatabaseConfigurationFactory,
                      databaseId: DatabaseID,
                      fileStorage: FileStorageConfigurationFactory,
                      fileStorageId: FileStorageID,
                      maxUploadSize: ByteCount = "10mb",
                      modules userModules: [ViperBuilder] = [],
                      usePublicFileMiddleware: Bool = true) throws {

//        app.directory.workingDirectory = "/Users/tib/"
//        app.directory.publicDirectory = "/Users/tib/"
//        app.directory.resourcesDirectory = "/Users/tib/"
//        app.directory.viewsDirectory = "/Users/tib/"

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
        LeafEngine.entities.use(InvokeHookLeafEntity(), asFunction: "InvokeHook")
        LeafEngine.entities.use(InvokeAllHooksLeafEntity(), asFunction: "InvokeAllHooks")
        LeafEngine.entities.use(InlineSvg(iconset: "feather-icons"), asFunction: "svg")
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
