//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 24..
//

public extension Request {

    var absoluteUrl: String {
        Feather.baseUrl + url.path.safePath()
    }
        
}
