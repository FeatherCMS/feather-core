//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 12..
//

public enum FieldSort: String, Codable, CaseIterable {
    case asc
    case desc
    
    public var direction: DatabaseQuery.Sort.Direction {
        switch self {
        case .asc:
            return .ascending
        case .desc:
            return .descending
        }
    }
}
