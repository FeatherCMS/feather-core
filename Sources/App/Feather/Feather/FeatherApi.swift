//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Foundation

public protocol FeatherApi: ListApi,
                            DetailApi,
                            CreateApi,
                            UpdateApi,
                            PatchApi,
                            DeleteApi
{
    
}
