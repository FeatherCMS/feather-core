//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

import Vapor
import Foundation


extension Feather {
    
    public struct Config: Codable {
        
        public struct Install: Codable {
            public var isCompleted: Bool
            public var currentStep: String?
            public var nextQueryKey: String
        }

        public struct Paths: Codable {
            public var admin: String
            public var api: String
            public var install: String
            public var redirectQueryKey: String
            public var login: String
            public var logout: String
            public var sitemap: String
            public var rss: String
            public var robots: String

            public var adminLogin: String {
                "/\(Feather.config.paths.login)/?\(Feather.config.paths.redirectQueryKey)=/\(Feather.config.paths.admin)/"
            }
        }
        
        public struct Locale: Codable {
            public var timezone: String
            public var locale: String
        }

        public var install: Install
        public var paths: Paths
        public var locale: Locale
        public var filters: [String]
        public var listLimit: Int
        
        fileprivate static var `default`: Config {
            .init(install: .init(isCompleted: false,
                                 currentStep: nil,
                                 nextQueryKey: "next"),
                  paths: .init(admin: "admin",
                               api: "api",
                               install: "install",
                               redirectQueryKey: "redirect",
                               login: "login",
                               logout: "logout",
                               sitemap: "sitemap.xml",
                               rss: "rss.xml",
                               robots: "robots.txt"),
                  locale: .init(timezone: "", locale: ""),
                  filters: [],
                  listLimit: 20)
        }
    }
    
    private static var _variables: Config?
    private static var _configUrl: URL {
        Application.Paths.resources.appendingPathComponent("config").appendingPathExtension("json")
    }
    
    public static var config: Config {
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
                let data = try JSONEncoder().encode(newValue)
                try data.write(to: _configUrl)
                _variables = newValue
            }
            catch {
                // do nothing...
            }
        }
    }
}


//    static var timezone: TimeZone {
//        get {
//            if let tzValue = get(.timezone), let tz = TimeZone(identifier: tzValue) {
//                return tz
//            }
//            return .autoupdatingCurrent
//        }
//        set {
//            set(.timezone, value: newValue.identifier)
//        }
//    }
//
//    static var locale: Locale {
//        get {
//            if let localeValue = get(.locale) {
//                return Locale(identifier: localeValue)
//            }
//            return .autoupdatingCurrent
//        }
//        set {
//            set(.locale, value: newValue.identifier)
//        }
//    }
//
