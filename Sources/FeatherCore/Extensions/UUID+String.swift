//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 18..
//

public extension UUID {
    
    var string: String {
        uuidString
    }
}

public extension String {

    var uuid: UUID? {
        .init(uuidString: self)
    }
}
