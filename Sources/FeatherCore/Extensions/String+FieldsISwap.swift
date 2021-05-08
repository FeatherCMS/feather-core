//
//  File.swift
//  
//
//  Created by Denis Martin on 06/05/2021.
//

import Foundation

private var cached📦Data = [String: [String: String]]()

public extension String {
    
    var 🐣: String { return 🐣() }
    
    func 🐣(_ label: String? = nil) -> String {
        return _label(type: "Forms", with: label)
    }
    
    var 🦅: String { return 🦅() }
    
    func 🦅(_ label: String? = nil) -> String {
        return _label(type: "Others", with: label)
    }

}


public extension Application {

    static internal func parseConfig(resource: String) -> [String: String] {
        if !FileManager.default.fileExists(atPath: Paths.fields.path) {
            try? FileManager.default.createDirectory(atPath: Paths.fields.path, withIntermediateDirectories: true, attributes: nil)
        }
        let jsonPath = Paths.fields.appendingPathComponent("\(resource).json")
        guard let jsonData = try? Data(contentsOf: jsonPath) else { return [String: String]() }
        if let fields: [String: String] = try? JSONDecoder().decode([String: String].self, from: jsonData) {
            return fields
        }
        /// Fill our cache
        if cached📦Data[resource] == nil {
            cached📦Data[resource] = [String: String]()
        }
        return cached📦Data[resource]!
    }
    
    static internal func save(resource: String, config: [String: String])  {
        cached📦Data[resource] = config
        let jsonPath = Paths.fields.appendingPathComponent("\(resource).json")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let data = try?  encoder.encode(cached📦Data[resource]) {
            try? data.write(to: jsonPath)
        }
    }
    
}

extension String {
    
    internal var unicodeString: String {
        var uni = ""
        for v in unicodeScalars {
            uni="\(uni)\(v.value)"
        }
        return uni
    }
    
    internal func _label(type: String, with label: String? = nil) -> String {
        /// Work only if requested
        guard Application.Config.fields.count > 0 else {
            return self
        }
        /// Return cache if available
        if let cached = cached📦Data[type]?[unicodeString] {
            return cached
        }
        /// Fetch value on disk and save it
        var properties = Application.parseConfig(resource: type)
        if label == nil,  properties[unicodeString] == nil  {
            properties[unicodeString] = "\(self)"
            cached📦Data[type] = properties
            Application.save(resource: type, config: properties)
            return "\(self)"
            
        } else if label == nil, let fromCache = properties[unicodeString] {
            cached📦Data[type] = properties
            return fromCache
        }
        return self
    }
}

