//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 04..
//


public extension Svg {

    static func icon(_ value: String) -> Svg? {
        guard let icon = Icons(rawValue: value) else {
            return nil
        }
        return .icon(icon)
    }
    
    static func icon(_ value: Icons) -> Svg {
        Svg {
            value.tags
        }
        .width(24)
        .height(24)
        .viewBox(minX: 0, minY: 0, width: 24, height: 24)
        .fill("none")
        .stroke("currentColor")
        .strokeWidth(2)
        .strokeLinecap("round")
        .strokeLinejoin("round")
    }
}


