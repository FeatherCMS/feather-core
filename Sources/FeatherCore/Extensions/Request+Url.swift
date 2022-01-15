//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 24..
//

public extension Request {

    var absoluteUrl: String {
        absoluteUrl(url.path)
    }
    
    func absoluteUrl(_ path: String) -> String {
        feather.baseUrl + path.safePath()
    }
        
}
