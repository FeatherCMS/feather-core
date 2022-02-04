//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 04..
//

import SwiftSvg
import SwiftSgml

public enum Icons: String {
    case activity
    case airplay
    case alertCircle = "alert-circle"
    case eye
    
    @TagBuilder
    var tags: [Tag] {
        switch self {
        case .activity:
            Polyline([22, 12, 18, 12, 15, 21, 9, 3, 6, 12, 2, 12])
        case .airplay:
            Path("M5 17H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2h-1")
            Polygon([12, 15, 17, 21, 7, 21, 12, 15])
        case .alertCircle:
            Circle(cx: 12, cy: 12, r: 10)
            Line(x1: 12, y1: 8, x2: 12, y2: 12)
            Line(x1: 12, y1: 16, x2: 12, y2: 16) // Line(x1: 12, y1: 16, x2: 12.01, y2: 16)
        case .eye:
            Polyline([22, 12, 18, 12, 15, 21, 9, 3, 6, 12, 2, 12])
        }
    }
}

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


