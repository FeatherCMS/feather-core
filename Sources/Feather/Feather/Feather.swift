//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

import Vapor
import Fluent
import FeatherApi

extension FeatherError: Content {}
extension FeatherErrorDetail: Content {}

extension FeatherUser: Content {}
extension FeatherPermission: Content {}
extension FeatherMetadata: Content {}
extension FeatherVariable: Content {}

public final class Feather {
    
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

    // paths are always absolute, with a trailing slash
    public struct Paths {
        public let base: URL

        init(_ path: String) {
            self.base = URL(fileURLWithPath: path)
        }

        public var resources: URL { base.appendingPathComponent(Directories.resources) }
        public var `public`: URL {  base.appendingPathComponent(Directories.public) }
        public var assets: URL {  `public`.appendingPathComponent(Directories.assets) }
        public var css: URL {  `public`.appendingPathComponent(Directories.css) }
        public var images: URL {  `public`.appendingPathComponent(Directories.images) }
        public var javascript: URL {  `public`.appendingPathComponent(Directories.javascript) }
        public var svg: URL {  `public`.appendingPathComponent(Directories.svg) }
    }
    
    /// Logger for messages not associated with a request.  Requests have their own logger instance.
    public static let logger = Logger(label: "feather-core")

    
    public static func dateFormatter(dateStyle: DateFormatter.Style = .short,
                                     timeStyle: DateFormatter.Style = .short) -> DateFormatter {
        let formatter = DateFormatter()
//        #warning("fixme")
//        formatter.timeZone = TimeZone(identifier: Feather.config.region.timezone)
//        formatter.locale = Locale(identifier: Feather.config.region.locale)
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter
    }

    unowned var app: Application
    public private(set) var moduleManager: FeatherModuleManager
    
    public let baseUrl: String
    public let workDir: String
    public let https: Bool
    public let hostname: String
    public let port: Int
    public let maxBodySize: ByteCount
    public let disableFileMiddleware: Bool
    public let disableApiSessionAuthMiddleware: Bool
    public let paths: Paths
    
    private var _variables: Config?
    private var _configUrl: URL {
        paths.resources.appendingPathComponent("config").appendingPathExtension("json")
    }

    public var config: Config {
        get {
            guard _variables == nil else {
                return _variables!
            }
            do {
                let data = try Data(contentsOf: _configUrl)
                _variables = try JSONDecoder().decode(Config.self, from: data)
            }
            catch {
                _variables = .default
            }
            return _variables!
        }
        set {
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let data = try encoder.encode(newValue)
                try data.write(to: _configUrl)
                _variables = newValue
            }
            catch {
                Feather.logger.error("Error writing \(_configUrl): \(error.localizedDescription)")
            }
        }
    }
    
    public init(app: Application) {
        self.app = app
        self.moduleManager = .init([])
        
        self.workDir = Environment.featherRequired("work_dir") + (app.environment == .testing ? UUID().uuidString + "/" : "")
        self.https = Environment.featherBool("https")
        self.hostname = Environment.featherString("hostname", "127.0.0.1")
        self.port = Environment.featherInt("port", 8080)
        self.maxBodySize = ByteCount(stringLiteral: Environment.featherString("max_body_size", "10mb"))
        self.disableFileMiddleware = Environment.featherBool("disable_file_middleware")
        self.disableApiSessionAuthMiddleware = Environment.featherBool("disable_api_session_middleware")
        self.baseUrl = (https ? "https" : "http") + "://" + hostname + ":" + (port == 80 ? "" : String(port))
        self.paths = Paths(workDir)
    }

    public func boot() {
        app.directory = .init(workingDirectory: workDir)
    }

    public func start(_ userModules: [FeatherModule] = [],
                      template: SystemModuleTemplate? = nil) throws {
        guard app.databases.configuration() != nil else {
            fatalError("Missing database configuration")
        }
        guard app.fileStorages.configuration() != nil else {
            fatalError("Missing file storage configuration")
        }

        app.http.server.configuration.hostname = hostname
        app.http.server.configuration.port = port
        app.routes.defaultMaxBodySize = maxBodySize
        
        if !disableFileMiddleware {
            app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
        }

        app.sessions.use(.fluent)
        app.migrations.add(SessionRecord.migration)
        app.middleware.use(app.sessions.middleware)
        app.middleware.use(FeatherGuestUserAuthenticator())
        app.middleware.use(FeatherVariableMiddleware())
        
        var systemTemplate: SystemModuleTemplate = DefaultSystemModuleTemplate()
        if let tpl = template {
            systemTemplate = tpl
        }
        moduleManager.add([SystemModule(template: systemTemplate)] + userModules)
        
        try createRequiredDirectories()
        try copySystemModuleBundle()
        try copyModuleBundles(moduleManager.modules)

        for module in moduleManager.modules {
            try module.boot(app)
        }
        for module in moduleManager.modules {
            try module.config(app)
        }
        try app.autoMigrate().wait()
    }
}

private extension Feather {
    
    func createRequiredDirectories() throws {
        let fm = FileManager.default
        try fm.createDirectory(at: paths.public)
        try fm.createDirectory(at: paths.resources)
    }

    func copyPublicFiles(at url: URL, to name: String) throws {
        let fm = FileManager.default
        let publicUrl = url.appendingPathComponent("Public")
        guard fm.isExistingDirectory(at: publicUrl.path) else {
            return
        }
        let publicDirectories = try fm.contentsOfDirectory(atPath: publicUrl.path)

        for dir in publicDirectories {
            let dirUrl = publicUrl.appendingPathComponent(dir)
            guard fm.isExistingDirectory(at: dirUrl.path) else {
                continue
            }
            let assetFiles = try fm.contentsOfDirectory(atPath: dirUrl.path)
            for file in assetFiles {
                let fileUrl = dirUrl.appendingPathComponent(file)
                let destDir = paths.public
                    .appendingPathComponent(dir)
                    .appendingPathComponent(name.lowercased())
                let destFile = destDir.appendingPathComponent(file)

                try fm.createDirectory(at: destDir)
                try fm.copy(at: fileUrl, to: destFile)
            }
        }
    }

    func copySystemModuleBundle() throws {
        Self.logger.warning(.init(stringLiteral: Bundle.module.resourceURL?.path ?? ""))
        guard let bundleUrl = Bundle.module.resourceURL?.appendingPathComponent("Bundle") else {
            Self.logger.warning("no system bundle")
            return
        }
        let moduleUrl = bundleUrl.appendingPathComponent(SystemModule.uniqueKey.capitalized)
        Self.logger.warning(.init(stringLiteral: moduleUrl.path))
        try copyPublicFiles(at: moduleUrl, to: SystemModule.uniqueKey)
    }
    
    func copyModuleBundles(_ modules: [FeatherModule]) throws {
        for module in modules.filter({ type(of: $0).bundleUrl != nil }) {
            let staticModule = type(of: module)
            let moduleUrl = staticModule.bundleUrl!
            let moduleName = staticModule.uniqueKey.lowercased()
            
            Self.logger.warning(.init(stringLiteral: moduleUrl.path))
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


