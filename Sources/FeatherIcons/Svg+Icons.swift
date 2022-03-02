//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 04..
//


extension Svg {
    
    static func icon(_ tags: [Tag]) -> Svg {
        Svg {
            tags
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
