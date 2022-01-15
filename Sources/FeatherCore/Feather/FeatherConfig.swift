//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//


    
public struct Config: Codable {
    
    public struct Install: Codable {
        public internal(set) var isCompleted: Bool
        public internal(set) var currentStep: String
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
    }
    
    public struct Region: Codable {
        public var timezone: String
        public var locale: String
    }

    public var install: Install
    public var paths: Paths
    public var region: Region
    public var filters: [String]
    public var listLimit: Int
    
    static var `default`: Config {
        .init(install: .init(isCompleted: false,
                             currentStep: SystemInstallStep.start.key,
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
              region: .init(timezone: "America/Los_Angeles", locale: "en_US"),
              filters: ["markdown", "swifty"],
              listLimit: 20)
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
