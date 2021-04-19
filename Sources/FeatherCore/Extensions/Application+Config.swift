//
//  Application+Config.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 11. 20..
//

extension Application {
    
    struct Config {

        fileprivate struct KeyValueStorage: Codable {
            
            static var url: URL { Application.Paths.resources.appendingPathComponent("config").appendingPathExtension("json") }

            private static var _cache: [String: String]? = nil

            static var current: [String: String] {
                if _cache == nil {
                    do {
                        let data = try Data(contentsOf: url)
                        _cache = try JSONDecoder().decode([String: String].self, from: data)
                    }
                    catch {
                        _cache = [:]
                    }
                }
                return _cache!
            }
            
            static func save(_ dict: [String: String]) {
                do {
                    let data = try JSONEncoder().encode(dict)
                    try data.write(to: url)
                }
                catch {
                    fatalError(error.localizedDescription)
                }
                _cache = nil
            }
        }

        fileprivate static func get(_ key: String) -> String? {
            return KeyValueStorage.current[key]
        }

        fileprivate static func set(_ key: String, value: String) {
            var dict = KeyValueStorage.current
            dict[key] = value
            KeyValueStorage.save(dict)
        }

        fileprivate static func unset(_ key: String) {
            var dict = KeyValueStorage.current
            dict.removeValue(forKey: key)
            KeyValueStorage.save(dict)
        }
    }
}

extension Application.Config {

    static var installed: Bool {
        get {
            if let rawValue = get("installed"), let value = Bool(rawValue) {
                return value
            }
            return false
        }
        set {
            set("installed", value: String(newValue))
        }
    }
    
    static var template: String {
        if let value = get("template") {
            return value
        }
        return "Default"
    }
    

    static var timezone: TimeZone {
        get {
            if let tzValue = get("timezone"), let tz = TimeZone(identifier: tzValue) {
                return tz
            }
            return .autoupdatingCurrent
        }
        set {
            set("timezone", value: newValue.identifier)
        }
    }

    static var locale: Locale {
        get {
            if let localeValue = get("locale") {
                return Locale(identifier: localeValue)
            }
            return .autoupdatingCurrent
        }
        set {
            set("locale", value: newValue.identifier)
        }
    }

    static var filters: [String] {
        get {
            if let filterValue = get("filters") {
                return filterValue.split(separator: ",").map(String.init)
            }
            return []
        }
        set {
            set("filters", value: newValue.joined(separator: ","))
        }
    }

    static func dateFormatter(dateStyle: DateFormatter.Style = .short, timeStyle: DateFormatter.Style = .short) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = timezone
        formatter.locale =  locale
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter
    }
}
