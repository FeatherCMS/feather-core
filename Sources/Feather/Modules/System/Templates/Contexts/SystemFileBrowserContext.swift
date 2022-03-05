//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 22..
//

struct SystemFileBrowserContext {

    let list: FeatherApi.System.File.Directory.List
    
    init(list: FeatherApi.System.File.Directory.List) {
        self.list = list
    }
}
