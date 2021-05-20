//
//  Context.swift
//  RequestProcessing
//
//  Created by Tibor Bodecs on 2021. 03. 25..
//

enum Context {
    
    case null
    case bool(Bool)
    case int(Int)
    case double(Double)
    case string(String)
    case array([Context])
    case object([String: Context])
    
    init?(_ value: Any?) {
        guard let value = value else {
            self = nil
            return
        }
        switch value {
        case let null as Optional<Any> where null == nil:
            self = .null
        case let bool as Bool:
            self = .bool(bool)
        case let int as Int:
            self = .int(int)
        case let double as Double:
            self = .double(double)
        case let str as String:
            self = .string(str)
        case let array as [Any]:
            self = .array(array.compactMap(Context.init))
        case let dict as [String: Any]:
            self = .object(dict.compactMapValues(Context.init))
        case let codable as Codable:
            self = codable.encode() ?? nil
        default:
            self = nil
        }
    }
    
    // MARK: - value getters
    
    var isNull: Bool {
        if case .null = self {
            return true
        }
        return false
    }
    
    var bool: Bool? {
        if case .bool(let value) = self {
            return value
        }
        return nil
    }
    
    var int: Int? {
        if case .int(let value) = self {
            return value
        }
        return nil
    }
    
    var double: Double? {
        if case .double(let value) = self {
            return value
        }
        return nil
    }
    
    var string: String? {
        if case .string(let value) = self {
            return value
        }
        return nil
    }
    
    var array: [Context]? {
        if case .array(let value) = self {
            return value
        }
        return nil
    }
    
    var object: [String: Context]? {
        get {
            if case .object(let value) = self {
                return value
            }
            return nil
        }
        set {
            self = .object(newValue ?? [:])
        }
    }
    
    
    subscript(key: String) -> Context? {
        get {
            if case .object(let dict) = self {
                return dict[key]
            }
            return nil
        }
        set {
            if case .object(var dict) = self {
                dict[key] = newValue
                self = .object(dict)
            }
        }
    }
    
    func merged(with new: Context?) -> Context {
        guard let new = new else {
            return self
        }
        guard case .object(let lhs) = self, case .object(let rhs) = new else {
            return new
        }
        var merged: [String: Context] = [:]
        for (key, val) in lhs where rhs[key] == nil {
            merged[key] = val
        }
        for (key, val) in rhs where lhs[key] == nil {
            merged[key] = val
        }
        for key in lhs.keys where rhs[key] != nil {
            merged[key] = lhs[key]?.merged(with: rhs[key]!)
        }
        return .object(merged)
    }
    
    func decode<T: Decodable>(_ type: T.Type) -> T?  {
        guard let encoded = try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONDecoder().decode(type, from: encoded)
    }
}

extension Encodable {
    
    func encode() -> Context? {
        guard let encoded = try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONDecoder().decode(Context.self, from: encoded)
    }
}

extension Context: Codable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .null:
            try container.encodeNil()
        case let .bool(bool):
            try container.encode(bool)
        case let .int(int):
            try container.encode(int)
        case let .double(double):
            try container.encode(double)
        case let .string(string):
            try container.encode(string)
        case let .array(array):
            try container.encode(array)
        case let .object(object):
            try container.encode(object)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        }
        else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        }
        else if let int = try? container.decode(Int.self) {
            self = .int(int)
        }
        else if let double = try? container.decode(Double.self) {
            self = .double(double)
        }
        else if let string = try? container.decode(String.self) {
            self = .string(string)
        }
        else if let array = try? container.decode([Context].self) {
            self = .array(array)
        }
        else if let object = try? container.decode([String: Context].self) {
            self = .object(object)
        }
        else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid value"))
        }
    }
}

extension Context: CustomDebugStringConvertible {
    
    var debugDescription: String {
        switch self {
        case .null:
            return "null"
        case .bool(let bool):
            return bool.description
        case .int(let int):
            return String(int).debugDescription
        case .double(let double):
            return String(double).debugDescription
        case .string(let str):
            return str.debugDescription
        default:
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted]
            if let data = try? encoder.encode(self) {
                return String(data: data, encoding: .utf8) ?? ""
            }
            return ""
        }
    }
}

extension Context: ExpressibleByNilLiteral {
    
    init(nilLiteral: ()) {
        self = .null
    }
}

extension Context: ExpressibleByBooleanLiteral {
    
    init(booleanLiteral value: Bool) {
        self = .bool(value)
    }
}

extension Context: ExpressibleByIntegerLiteral {
    
    init(integerLiteral value: Int) {
        self = .int(value)
    }
}

extension Context: ExpressibleByFloatLiteral {
    
    init(floatLiteral value: Double) {
        self = .double(value)
    }
}

extension Context: ExpressibleByStringLiteral {
    
    init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension Context: ExpressibleByArrayLiteral {
    
    init(arrayLiteral elements: Context...) {
        self = .array(elements)
    }
}

extension Context: ExpressibleByDictionaryLiteral {
    
    init(dictionaryLiteral elements: (String, Context)...) {
        var object: [String: Context] = [:]
        for (k, v) in elements {
            object[k] = v
        }
        self = .object(object)
    }
}


