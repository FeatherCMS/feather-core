//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

import Vapor

public struct Feather {
    
    /*
     # .env example
     FEATHER_WORK_DIR=/Users/me/feather
     FEATHER_HTTPS=false
     FEATHER_DOMAIN=localhost
     FEATHER_PORT=8080
     FEATHER_MAX_BODY_SIZE=10mb
     FEATHER_DISABLE_FILE_MIDDLEWARE=true
     FEATHER_DISABLE_API_SESSION_MIDDLEWARE=true
     */
    private static let workDir = Environment.featherRequired("work_dir")
    private static let https = Environment.featherBool("https")
    private static let hostname = Environment.featherString("hostname", "127.0.0.1")
    private static let port = Environment.featherInt("port", 8080)
    private static let maxBodySize = ByteCount(stringLiteral: Environment.featherString("max_body_size", "10mb"))
    private static let disableFileMiddleware = Environment.featherBool("disable_file_middleware")
    internal static let disableApiSessionAuthMiddleware = Environment.featherBool("disable_api_session_middleware")
    
    /// without trailing slash
    public static let baseUrl: String = (Feather.https ? "https" : "http") + "://" + Feather.hostname + ":" + (Feather.port == 80 ? "" : String(Feather.port))

    // paths are always absolute, with a trailing slash
    public struct Paths {
        public static let base = URL(fileURLWithPath: Feather.workDir)

        public static let resources = base.appendingPathComponent(Directories.resources)
        public static let `public` = base.appendingPathComponent(Directories.public)
        public static let assets = `public`.appendingPathComponent(Directories.assets)
        public static let css = `public`.appendingPathComponent(Directories.css)
        public static let images = `public`.appendingPathComponent(Directories.images)
        public static let javascript = `public`.appendingPathComponent(Directories.javascript)
        public static let svg = `public`.appendingPathComponent(Directories.svg)
    }

    // locations are always relative with a trailing slash
    public struct Directories {
        public static let resources: String = "Resources"        
        public static let `public`: String = "Public"
        public static let assets: String = "assets"
        public static let css: String = "css"
        public static let images: String = "img"
        public static let javascript: String = "js"
        public static let svg: String = "svg"
    }
    
    /// Logger for messages not associated with a request.  Requests have their own logger instance.
    public static let logger = Logger(label: "feather-core")

    public static func dateFormatter(dateStyle: DateFormatter.Style = .short,
                                     timeStyle: DateFormatter.Style = .short) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: Feather.config.region.timezone)
        formatter.locale = Locale(identifier: Feather.config.region.locale)
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter
    }

    var app: Application
    public private(set) var modules: [FeatherModule]
    
    public init(app: Application) {
        self.app = app
        self.modules = []
    }

    
    public mutating func start(_ userModules: [FeatherModule] = []) throws {
        
        guard app.databases.configuration() != nil else {
            fatalError("Missing database configuration")
        }
        guard app.fileStorages.configuration() != nil else {
            fatalError("Missing file storage configuration")
        }
        
        app.http.server.configuration.hostname = Self.hostname
        app.http.server.configuration.port = Self.port
        app.routes.defaultMaxBodySize = Self.maxBodySize
        
        if !Self.disableFileMiddleware {
            app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
        }
        
        app.sessions.use(.fluent)
        app.migrations.add(SessionRecord.migration)
        app.middleware.use(app.sessions.middleware)
        
        modules = [
            SystemModule(),
            UserModule(),
            CommonModule(),
            AdminModule(),
            WebModule(),
        ] + userModules
        
        try createRequiredDirectories()
        try copyCoreModuleBundles()
        try copyModuleBundles(modules)

        for module in modules {
            try module.boot(app)
        }
        for module in modules {
            try module.config(app)
        }
        try app.autoMigrate().wait()
    }
}

private extension Feather {
    
    func createRequiredDirectories() throws {
        let fm = FileManager.default
        try fm.createDirectory(at: Feather.Paths.public)
        try fm.createDirectory(at: Feather.Paths.resources)
    }

    func copyPublicFiles(at url: URL, to name: String) throws {
        let fm = FileManager.default
        let publicUrl = url.appendingPathComponent("Public")
        let publicDirectories = try fm.contentsOfDirectory(atPath: publicUrl.path)

        for dir in publicDirectories {
            let dirUrl = publicUrl.appendingPathComponent(dir)
            let assetFiles = try fm.contentsOfDirectory(atPath: dirUrl.path)

            for file in assetFiles {
                let fileUrl = dirUrl.appendingPathComponent(file)
                let destDir = Feather.Paths.public
                    .appendingPathComponent(dir)
                    .appendingPathComponent(name.lowercased())
                let destFile = destDir.appendingPathComponent(file)

                try fm.createDirectory(at: destDir)
                try fm.copy(at: fileUrl, to: destFile)
            }
        }
    }

    func copyCoreModuleBundles() throws {
        guard
            let coreModulesUrl = Bundle.module.resourceURL?
                .appendingPathComponent("Bundle")
                .appendingPathComponent("Modules")
        else {
            return
        }
        for module in try FileManager.default.contentsOfDirectory(atPath: coreModulesUrl.path) {
            let moduleUrl = coreModulesUrl.appendingPathComponent(module)
            try copyPublicFiles(at: moduleUrl, to: module)
        }
    }
    
    func copyModuleBundles(_ modules: [FeatherModule]) throws {
        for module in modules.filter({ $0.bundleUrl != nil }) {
            let moduleUrl = module.bundleUrl!
            let moduleName = type(of: module).featherIdentifier.lowercased()
            try copyPublicFiles(at: moduleUrl, to: moduleName)
        }
    }
    
    // MARK: - experimental dylib

    /// @NOTE: work in progress, do not use this method yet
    ///
    /// Big thanks to [Lopdo](https://github.com/Lopdo) for the plugin loader sample code. 🙏
    ///
//    private static func loadDynamicModuleBuilder(named name: String, _ app: Application) -> FeatherModuleBuilder {
//        let moduleName = name
//        let path = app.directory.resourcesDirectory + "Modules/libDynamic\(moduleName)Module.dylib"
//
//        guard let dylibReference = dlopen(path, RTLD_NOW|RTLD_LOCAL) else {
//            if let err = dlerror() {
//                fatalError(String(format: "dlopen error - %s", err))
//            }
//            else {
//                fatalError("unknown dlopen error")
//            }
//        }
//        defer {
//            dlclose(dylibReference)
//        }
//        let symbolName = "create\(moduleName)Module"
//
//
//        guard let symbol = dlsym(dylibReference, symbolName) else {
//            fatalError("dlsym error - create module symbol not found")
//        }
//
//        typealias InitFunction = @convention(c) () -> UnsafeMutableRawPointer
//        let f: InitFunction = unsafeBitCast(symbol, to: InitFunction.self)
//        let pointer = f()
//        let builder = Unmanaged<FeatherModuleBuilder>.fromOpaque(pointer).takeRetainedValue()
//        return builder
//    }
}


//@_cdecl("createBlogModule")
//public func createBlogModule() -> UnsafeMutableRawPointer {
//    return Unmanaged.passRetained(BlogBuilder()).toOpaque()
//}
//
//public final class BlogBuilder: FeatherModuleBuilder {
//
//    public override func build() -> FeatherModule {
//        BlogModule()
//    }
//}
