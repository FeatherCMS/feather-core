//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 22..
//

import FeatherApi

struct SystemFileBrowserContext {

    let list: FeatherFile.List
    
    init(list: FeatherFile.List) {
        self.list = list
    }
}
