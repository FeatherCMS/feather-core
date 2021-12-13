//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

import Vapor
import Foundation


extension Feather {
    
    struct Config: Codable {
        
        struct Install: Codable {
            var isCompleted: Bool
            var currentStep: String?
            var nextQueryKey: String
        }

        struct Paths: Codable {
            var admin: String
            var api: String
            var redirectQueryKey: String
            var login: String
            var logout: String
            var sitemap: String
            var rss: String
            var robots: String

            var adminLogin: String {
                "/\(Feather.config.paths.login)/?\(Feather.config.paths.redirectQueryKey)=/\(Feather.config.paths.admin)/"
            }
        }
        
        struct Locale: Codable {
            var timezone: String
            var locale: String
        }

        var install: Install
        var paths: Paths
        var locale: Locale
        var filters: [String]
        var listLimit: Int
        
        fileprivate static var `default`: Config {
            .init(install: .init(isCompleted: false,
                                 currentStep: nil,
                                 nextQueryKey: "next"),
                  paths: .init(admin: "admin",
                               api: "api",
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
