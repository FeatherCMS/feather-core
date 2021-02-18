//
//  Application+Static.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 11. 20..
//

public extension Application {
    
    static let baseUrl: String = Environment.fetch("BASE_URL")

    // paths are always absolute, with a trailing slash
    struct Paths {
        public static let base = URL(fileURLWithPath: Environment.path("BASE_PATH"))

        public static let resources = base.appendingPathComponent(Directories.resources)
        public static let templates = resources.appendingPathComponent(Directories.templates)
        
        public static let `public` = base.appendingPathComponent(Directories.public)
        public static let assets = `public`.appendingPathComponent(Directories.assets)
        public static let css = `public`.appendingPathComponent(Directories.css)
        public static let images = `public`.appendingPathComponent(Directories.images)
        public static let javascript = `public`.appendingPathComponent(Directories.javascript)
    }

    // locations are always relative with a trailing slash
    struct Directories {
        public static let resources: String = "Resources"
        public static let templates: String = "Templates"
        
        public static let `public`: String = "Public"
        public static let assets: String = "assets"
        public static let css: String = "css"
        public static let images: String = "images"
        public static let javascript: String = "javascript"
    }
}
