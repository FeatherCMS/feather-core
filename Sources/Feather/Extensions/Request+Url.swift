//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 24..
//

import Vapor

public extension Request {

    var absoluteUrl: String {
        absoluteUrl(url.path)
    }
    
    func absoluteUrl(_ path: String) -> String {
        feather.publicUrl + path.safePath()
    }
        
}
