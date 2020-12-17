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
        public static let base: String = Environment.path("BASE_PATH")
        public static let `public`: String = Paths.base + "Public/"
        public static let assets: String = Paths.public + "assets/"
        public static let resources: String = Paths.base + "Resources/"
    }

    // locations are always relative with a trailing slash
    struct Locations {
        public static let assets: String = "assets/"
        public static let css: String = "css/"
        public static let images: String = "images/"
        public static let javascript: String = "javascript/"
    }
}
